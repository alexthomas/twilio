require "twilio/engine"
require 'httparty'

module Twilio
  autoload :TwilioObject, '/twilio/API/TwilioObject'
  autoload :SMS, '/twilio/API/SMS'
  
  mattr_accessor :app_root
  @@app_root = ''
  
  mattr_accessor :twilio_account_sid
  @@twilio_account_sid = ''

  mattr_accessor :twilio_auth_token
  @@twilio_auth_token = ''
  
  mattr_accessor :twilio_app_id
  @@twilio_auth_token = ''
  
  API_VERSION = '2010-04-01'
  
  HTTP_HEADERS = {
          'Accept' => 'application/json',
          'Accept-Charset' => 'utf-8',
          'User-Agent' => "twilio-client/#{Twilio::VERSION}",
        }
        
  DEFAULTS = {
          :host => 'api.twilio.com',
          :port => 443,
          :use_ssl => true,
          :ssl_verify_peer => true,
          :ssl_ca_file => File.dirname(__FILE__) + '/../../../conf/cacert.pem',
          :timeout => 30,
          :proxy_addr => nil,
          :proxy_port => nil,
          :proxy_user => nil,
          :proxy_pass => nil,
          :retry_limit => 1,
        }
  
  def self.setup
    yield self
  end
      
  [:get, :put, :post, :delete].each do |method|
    define_singleton_method method do |path,options|
      Rails.logger.debug "defining #{method }method"
      options ||= {}
      api_endpoint = self.build_endpoint(path)
      HTTParty.send(:get, api_endpoint,:query => options,:headers => HTTP_HEADERS)
    end
    
  end
  
  def self.build_endpoint(path)
    url = "http://#{DEFAULTS[:host]}/#{API_VERSION}/Accounts/#{Twilio.twilio_account_sid}/#{path}"
    Rails.logger.debug "Twilio endpoint url #{url}"
    url
  end
  
  
  
end
