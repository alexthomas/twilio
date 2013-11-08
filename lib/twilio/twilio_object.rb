module Twilio

    class TwilioObject
      
      cattr_accessor :path, :find_params
      @@find_params = [:from,:to]
      @@path = ''
      
      attr_accessor :path, :options
      
      def initialize(params = {})
        params = {} unless params.is_a?(Hash)
        @options = TwilioObject.twilify_params(params) 
      end
      
      def set_object_vars_from_hash(hash)
        object_var_hash = TwilioObject.detwilify_params(hash.with_indifferent_access[:TwilioResponse][self.klass.to_sym])
        object_var_hash.each {|method_name,value|self.instance_variable_set("@#{method_name}", value) if self.respond_to?(method_name)}
      end
      
      def klass
        self.class.name.split("::").last
      end
      
      def update_attributes(params = {})
        params.keys.each do | param |
          params.delete(param) if !self.respond_to?("#{param}=".to_sym)
        end
        Twilio.post(@path,params)
      end
      
      def self.create(params = {})
        to = self.new(params)
        response = Twilio.post(self.path,to.options)
        to.set_object_vars_from_hash(TwiML.to_hash(response.body))
        to
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
        twilio_params = twilify_params(params)
        response = Twilio.get(self.path,twilio_params)
          resource_list = response.map do | resource |
          self.new(resource)
        end
      end
      
      def self.twilify_params(params = {})
        twilio_params = Hash[params.dup.with_indifferent_access.map do |k,v|
          uk = k.underscore.downcase
          #self.find_params.include?(uk.to_sym) ? [uk,v] : next
          [uk,v]
        end]
        # 
        # twilio_params.keys.each do | key |
        #   downcase_key = key.downcase
        #   underscore_key = downcase_key.underscore
        #   if !self.find_params.include? underscore_key.to_sym
        #     twilio_params.delete(key) 
        #   else
        #     if(key != downcase_key)
        #       twilio_params[downcase_key] = twilio_params[key]
        #       twilio_params.delete(key) 
        #       key = downcase_key
        #     end
        #     if(key != underscore_key)
        #       twilio_params[underscore_key] = twilio_params[key]; 
        #       twilio_params.delete(key) 
        #     end
        #   end
        # end
        # twilio_params
      end
      
      def self.detwilify_params(params = {})
        twilio_params = Hash[params.dup.with_indifferent_access.map do |k,v|
          uk = k.underscore.downcase
          #self.find_params.include?(uk.to_sym) ? [uk,v] : next
          [uk,v]
        end]
       
      end
      
    end

end