require 'gserver'
require 'freec_logger'

class Listener < GServer  
  DEFAULT_PORT = '8084'
  DEFAULT_IP = '127.0.0.1'
  
  def initialize(application_class_name, config) #:nodoc:
    @application_class_name = application_class_name
    @logger = FreecLogger.new(dev_or_test? ? STDOUT : @@log_file)
    @logger.level = Logger::INFO unless dev_or_test?
    @config = config
    host = @config['listen_ip'] || DEFAULT_IP
    port = @config['listen_port'] || DEFAULT_PORT
    super(port.to_i, host, (1.0/0.0))
    self.audit = true
    connect_to_database
  end
        
  def serve(io) #:nodoc:
    app = Kernel.const_get(@application_class_name).new(io, @logger, @config)
    app.handle_call
  rescue StandardError => e
    @logger.error e.message
    e.backtrace.each {|trace_line| @logger.error(trace_line)}    
  end

private
  
  def connect_to_database
    return unless @@config['database'] && @@config['database'][ENVIRONMENT]
    require 'active_record'
    ActiveRecord::Base.establish_connection(@@config['database'][ENVIRONMENT])
  end  
  
  def dev_or_test?
    ['development', 'test'].include?(ENVIRONMENT)
  end
  
end
