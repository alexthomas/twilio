module Twilio

    class Message < TwilioObject
      
      attr_accessor :from, :to, :body, :media_url
      
      def initialize(params = {})
        @path = 'SMS/Messages'
        @options = params
        super
      end

    end

end