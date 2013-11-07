module Twilio
    class ServerError < StandardError; end
    
    class RequestError < StandardError
      attr_reader :code

      def initialize(message, code=nil)
        super message
        @code = code
      end
    end
    
    class TwiMLError < StandardError
      attr_reader :verb
      def initialize(verb)
        message = "#{verb} is not a valid TwiML verb"
        super message
      end
    end
end