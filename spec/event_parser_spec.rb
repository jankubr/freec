require "#{File.dirname(__FILE__)}/spec_helper"

describe Freec do
  before do
    io = stub(:io)
    log = FreecLogger.new(STDOUT)
    log.level = Logger::FATAL
    @freec = Freec.new(io, log)
  end
  
  describe "parses body-less event" do

    before do
      @freec.instance_variable_set(:@response, EVENT)
      @freec.send :parse_response
    end
    
    it "should read unique id from response" do
      @freec.instance_variable_get(:@unique_id).should == 'f3c2d5ee-d064-4f55-9280-5be2a65867e8'
    end
    
    it "should parse variables from response" do
      @freec.call_vars[:call_direction].should == 'inbound'
      @freec.call_vars[:caller_context].should == 'default'
      @freec.call_vars[:application].should == 'set'
    end    
  
    it "should make the value of the sip_from_user variable available as a method" do
      @freec.sip_from_user.should == '1001'
    end

    it "should make the value of the sip_to_user variable available as a method" do
      @freec.sip_to_user.should == '886'
    end

    it "should make the value of the channel_destination_number variable available as a method" do
      @freec.channel_destination_number.should == '886'
    end
  end

  describe "parses an event with a body" do
    before do
      @freec.instance_variable_set(:@response, EVENT_WITH_BODY)
      @freec.send :parse_response
    end
      
    it "should parse the variables from the event header" do
      @freec.call_vars[:event_name].should == 'DETECTED_SPEECH'
    end
    
    it "makes the body of the response available as a public method" do
      @freec.event_body.should =~ /<\/interpretation>$/
    end

  end
end