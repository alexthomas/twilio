module Twilio

    class Call < TwilioObject
      
      @@path = 'Calls'
      @@find_params = [:from,:to]
      attr_accessor :from, :to
      
      def initialize(params = {})
        
        @options = params
        super
      end
      
      def self.build_twilio_params(params)
        twilio_params = super(twilio_params)
        
      end
      
      def self.build_twilio_date_param!(twilio_params)
        if !(date_keys = %w(sent_before sent_after sent_on_or_before sent_on_or_after) & twilio_params.keys).empty?
          date_key = date_keys.first
          comparator = date_key =~ /on/ ? '=' : ''
          comparator = date_key =~ /before$/ ? "<#{comparator}" : ">#{comparator}"
          twilio_params[:date_sent] = "DateSent#{comparator}#{twilio_params[date_key].to_s}"
        end
        twilio_params
      end
    end

end