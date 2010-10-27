require "#{File.dirname(__FILE__)}/spec_helper"

module FreecSpecHelper
  def event_parts(event=EVENT)
    @parts = event.split("\n\n").map {|p| "#{p}\n\n"}  
  end
  
  def initial_response
    @initial_response ||= EVENT.split("\n\n")[1] + "\n\n"
  end
  
end

describe Freec do
  include FreecSpecHelper

  before do
    @io = stub(:io)
    @log = FreecLogger.new(STDOUT)
    @log.level = Logger::FATAL
    @config = {:config1 => 'value'}
    @freec = Freec.new(@io, @log, @config)
  end
  
  describe "initialization" do

    it "makes log and config available" do
      @freec.log.should == @log
      @freec.config.should == @config
    end

  end

  describe "call initialization" do
  
    it "sends 'connect' command to Freeswitch" do
      @freec.should_receive(:send_data).with("connect")
      @freec.should_receive(:send_data)
      @freec.should_receive(:send_data)
      @freec.should_receive(:send_data)
      @io.should_receive(:gets).exactly(4).and_return(initial_response)
      @freec.send :call_initialization
    end
    
    it "subscribes to events" do
      @freec.should_receive(:send_data)
      @freec.should_receive(:send_data).with('events plain all')
      @freec.should_receive(:send_data).with('filter Unique-ID f3c2d5ee-d064-4f55-9280-5be2a65867e8')
      @freec.should_receive(:send_data).with('divert_events on')
      @io.should_receive(:gets).exactly(4).and_return(initial_response)
      @freec.send :call_initialization
    end
    
  end
  
  describe "response reader" do
  
    it "reads the full body-less event" do
      @io.should_receive(:gets).and_return(event_parts(EVENT)[0], event_parts(EVENT)[1])
      @freec.send(:read_response)
    end
    
    it "reads the full event with body" do
      @io.should_receive(:gets).and_return(event_parts(EVENT_WITH_BODY)[0], 
                                          event_parts(EVENT_WITH_BODY)[1])
      @io.should_receive(:read).and_return(event_parts(EVENT_WITH_BODY)[2].strip.chomp)
      @freec.send(:read_response)
    end
  
  end
  
  
  describe "event recognition" do

    it "ignores events for another channel" do
      @freec.should_receive(:read_response).twice
      @freec.should_receive(:parse_response).and_return(false, true)
      @freec.send(:read_and_parse_response)
    end
  
    it "should subscribe to events of other leg channel after bridge" do
      bridge_event = EVENT.sub('CHANNEL_EXECUTE', 'CHANNEL_BRIDGE').sub('Caller-Profile-Index: 1', 'Other-Leg-Unique-ID: 6c75cb42-e72d-48bf-9ecf-d71bd4b60617')
      @freec.instance_variable_set(:@response, bridge_event)
      @freec.send(:parse_response)
      @freec.should_receive(:send_and_read).with("filter Unique-ID 6c75cb42-e72d-48bf-9ecf-d71bd4b60617")
      @freec.send(:subscribe_to_new_channel_events)
      @freec.instance_variable_get(:@want_events_from).should == ["f3c2d5ee-d064-4f55-9280-5be2a65867e8", "6c75cb42-e72d-48bf-9ecf-d71bd4b60617"]
    end
    
    it "should recognize last event was DTMF to call the on_dtmf callback" do
      dtmf_event = EVENT.sub('CHANNEL_EXECUTE', 'DTMF')
      @freec.instance_variable_set(:@response, dtmf_event)
      @freec.send(:parse_response)
      @freec.send(:last_event_dtmf?).should be_true
    end
      
    it "should recognize an event as a non-DTMF one" do
      @freec.instance_variable_set(:@response, EVENT)
      @freec.send(:parse_response)
      @freec.send(:last_event_dtmf?).should be_false
    end
      
    it "should recognize that app execution has been completed for the last run app" do
      @freec.instance_variable_set(:@last_app_executed, 'set')
      set_executed_event = EVENT.sub('CHANNEL_EXECUTE', 'CHANNEL_EXECUTE_COMPLETE')
      @freec.instance_variable_set(:@response, set_executed_event)
      @freec.send(:parse_response)      
    
      @freec.send(:execute_completed?).should be_true
      @freec.instance_variable_get(:@last_app_executed).should be_nil
    end
      
    it "should recognize that app execution has been completed but not for the last run one" do
      @freec.instance_variable_set(:@last_app_executed, 'different')
      set_executed_event = EVENT.sub('CHANNEL_EXECUTE', 'CHANNEL_EXECUTE_COMPLETE')
      @freec.instance_variable_set(:@response, set_executed_event)
      @freec.send(:parse_response)      
    
      @freec.send(:execute_completed?).should be_false
      @freec.instance_variable_get(:@last_app_executed).should == 'different'
    end
      
    it "should hangup the call, send exit command to Freeswitch and disconnect from it when step callback returns nil" do
      @freec.should_receive(:send_data).with("connect")
      @freec.should_receive(:send_data).with("events plain all")      
      @freec.should_receive(:send_data).with('filter Unique-ID f3c2d5ee-d064-4f55-9280-5be2a65867e8')
      @freec.should_receive(:send_data).with('divert_events on')
      
      @io.should_receive(:gets).and_return(initial_response, initial_response, initial_response, initial_response, "bye\n\n")
      @io.should_receive(:closed?).twice.and_return(false)
      @freec.should_receive(:step).and_return(nil)
      @freec.should_receive(:execute_app).with('hangup')
      @freec.should_receive(:on_hangup)
      @freec.should_receive(:send_data).with("exit")      
      @freec.handle_call
    end
    
    it "should exit when Freeswitch disconnects (e.g. caller hangs up) and neither call the step callback nor send any other data to Freeswitch" do
      disconnect_event = EVENT.sub('text/event-plain', 'text/disconnect-notice')
      @freec.should_receive(:send_data).with("connect")
      @freec.should_receive(:send_data).with("events plain all")      
      @freec.should_receive(:send_data).with('filter Unique-ID f3c2d5ee-d064-4f55-9280-5be2a65867e8')
      @freec.should_receive(:send_data).with('divert_events on')
      @io.should_receive(:gets).and_return(initial_response, initial_response, event_parts(disconnect_event)[0], event_parts(disconnect_event)[1])
      @io.should_receive(:closed?).twice.and_return(true)
      @freec.should_receive(:step).never
      @freec.should_receive(:on_hangup)
      @freec.should_receive(:execute_app).never      
      @freec.should_receive(:send_data).never
      @freec.handle_call
    end
      
  end
  
  describe "callback exception handling" do  
    it "should catch and log any exception occurred in a callback" do
      @freec.should_receive(:callback_name).and_raise(RuntimeError)
      @freec.log.should_receive(:error).with('RuntimeError')
      @freec.log.should_receive(:error).at_least(1).times #backtrace
      lambda { @freec.send(:callback, :callback_name) }.should_not raise_error(Exception)
    end  
  end
  
  describe "custom waiting conditions" do
    
    # it "should return true from waiting_for_this_response? when the conditions for the response are met" do
    #   @freec.wait_for(:content_type, 'command/reply')
    #   @freec.instance_variable_set(:@response, EVENT)
    #   @freec.send(:parse_response)
    #   @freec.send(:waiting_for_this_response?).should be_true
    # end
    #   
    # it "should return false from waiting_for_this_response? when the conditions for the response are not met" do
    #   @freec.wait_for(:content_type, 'text/event-plain')
    #   @freec.instance_variable_set(:@response, EVENT)
    #   @freec.send(:parse_response)
    #   @freec.send(:waiting_for_this_response?).should be_false
    # end
    #   
    # it "should reset the waiting conditions after they have been met" do      
    #   @freec.wait_for(:content_type, 'command/reply')
    #   @freec.should_receive(:send_data).with("connect")
    #   @freec.should_receive(:send_data).with("myevents")      
    #   @io.should_receive(:gets).and_return(EVENT, EVENT, "bye\n\n")
    #   @freec.instance_variable_set(:@last_app_executed, 'set')
    #   @freec.should_receive(:step).and_return(nil)
    #   @freec.should_receive(:execute_app).with('hangup')
    #   @freec.should_receive(:on_hangup)
    #   @freec.should_receive(:send_data).with("exit")      
    #   @freec.handle_call
    #   @freec.send(:waiting_for_this_response?).should be_nil
    # end
    #   
  end

end