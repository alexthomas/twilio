module Twilio
  module TwiML
    
    def self.build &block
      twiml = Builder::XmlMarkup.new(:indent => 2)
      twiml.instance_eval do
        def method_missing(meth, *args, &blk)
          # Capitalise methods but keep parent builder generating xml
          super(meth.to_s.capitalize, *args, &blk)
        end
      end
      twiml.instruct!
      twiml.response &block
    end
    
    def self.to_hash(twiML)
      Rails.logger.debug "twiml: #{twiML}"
      Hash.from_xml(twiML)
    end
    
  end
  
end