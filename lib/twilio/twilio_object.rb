module Twilio

    class TwilioObject
      
      attr_accessor :path,:options
      
      def initialize(params = {})
        @options = params.with_indifferent_access 
      end
      
      def self.create(options = {})
        to = self.new(options)
        Twilio.post(to.path,to.options)
      end
      

    end

end