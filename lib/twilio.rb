require "twilio/engine"
require "net/http"
require "builder"
require "jwt"

module Twilio

  require "twilio/twilio_object"
  require "twilio/errors"
  require "twilio/capability"
  require "twilio/call"
  require "twilio/message"
  require "twilio/twiml"
  
  
  
  mattr_accessor :app_root
  @@app_root = ''

  mattr_accessor :twilio_account_sid
  @@twilio_account_sid = ''

  mattr_accessor :twilio_auth_token
  @@twilio_auth_token = ''
  
  mattr_accessor :twilio_app_id
  @@twilio_auth_token = ''
  
  mattr_accessor :twilio_phone_number
  @@twilio_phone_number = ''
  
  mattr_accessor :twilio_test_number
  @@twilio_test_number = ''
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
    define_singleton_method method do |path,params|
      params ||= {}
      api_endpoint = self.build_endpoint(path)
      #HTTParty.send(method, api_endpoint,:query => options,:basic_auth => {:username => Twilio.twilio_account_sid, :password => Twilio.twilio_auth_token})
      api_path = (method==:get && !params.empty?) ? api_endpoint << encode_uri_get_params(params) : api_endpoint
      uri = URI(api_path)
      method_class = Net::HTTP.const_get method.to_s.capitalize
      request = method_class.new(uri)
      request.basic_auth Twilio.twilio_account_sid, Twilio.twilio_auth_token
      
      
      request.set_form_data(Twilio.twilify_post_data(params)) if [:put,:post].include? method
      
      retries_left = DEFAULTS[:retry_limit]
      
      begin
        response = Net::HTTP.start(uri.hostname, uri.port,:use_ssl => uri.scheme == 'https') {|http|
          http.request(request)
        
        }
        
      rescue Exception
        raise if request.class == Net::HTTP::Post        
        if retries_left > 0 then retries_left -= 1; retry else raise end
      end
      
      if response.kind_of? Net::HTTPServerError
        raise Twilio::ServerError.new
      end
      
      if response.kind_of? Net::HTTPClientError
        raise Twilio::RequestError.new "#{response.message} #{response.body}" , response.code
      end
      response
     end
    
  end

  def self.encode_uri_get_params(params)
    path = "?"
    path << params.to_a.map {|kv_pair| kv_pair.map {|v| CGI.escape v.to_s}.join('=')}.join('&')
  end
  def self.twilify_post_data(post_hash)
    post_hash.keys.each do | key |
      
      if key.is_a? String
        post_hash[key.capitalize] = post_hash[key]
        post_hash.delete(key)
      end
    end
    post_hash
  end
  
  def self.build_endpoint(path)
    url = "https://#{DEFAULTS[:host]}/#{API_VERSION}/Accounts/#{Twilio.twilio_account_sid}/#{path}"
  end
  
  
  
end
