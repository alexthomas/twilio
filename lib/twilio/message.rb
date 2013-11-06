module Twilio

    class Message < TwilioObject
      
      @@path = 'SMS/Messages'
      @@find_params = [:from,:to,:date_sent]
      attr_accessor :from, :to, :body, :media_url
      
      def initialize(params = {})
        
        @options = params
        super
      end
      
      def self.build_twilio_params(params)
        Rails.logger.debug "in message build twilio params"
        twilio_params = params.with_indifferent_access
        build_twilio_date_param!(twilio_params)
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