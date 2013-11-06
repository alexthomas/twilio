module Twilio

    class TwilioObject
      
      cattr_accessor :path, :find_params
      @@find_params = [:from,:to]
      @@path = ''
      
      attr_accessor :path, :options
      
      def initialize(params = {})
        @options = params.with_indifferent_access 
      end
      
      def self.create(options = {})
        to = self.new(options)
        Twilio.post(self.path,to.options)
      end
      
      def self.twilify_time_key(twilio_key,time_key,time_value)
        comparator = time_key =~ /on/ ? '=' : ''
        comparator = time_key =~ /before$/ ? "<#{comparator}" : ">#{comparator}"
        yield "#{twilio_key.to_s.camelize}#{comparator}#{time_value.to_s}"
      end
      
      def find(id)
        self.new(Twilio.get("#{self.path}/#{id}"))
      end
      
      #eventaully make recursive to get all not just last x
      def self.all(params = {})
        self.find_by(*params)
      end
      
      def self.find_by(params = {})
        return {}  if params.blank? || !params.is_a?(Hash)
        twilio_params = build_twilio_params(params)
        response = Twilio.get(self.path,twilio_params)
          resource_list = response.map do | resource |
          self.new(resource)
        end
      end
      
      def self.build_twilio_params(params = {})
        twilio_params = params.dup.with_indifferent_access
        twilio_params.keys.each do | key |
          downcase_key = key.downcase
          underscore_key = downcase_key.underscore
          if !self.find_params.include? underscore_key.to_sym
            twilio_params.delete(key) 
          else
            if(key != downcase_key)
              twilio_params[downcase_key] = twilio_params[key]
              twilio_params.delete(key) 
              key = downcase_key
            end
            if(key != underscore_key)
              twilio_params[underscore_key] = twilio_params[key]; 
              twilio_params.delete(key) 
            end
          end
        end
        twilio_params
      end
      
    end

end