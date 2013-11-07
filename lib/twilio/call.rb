module Twilio

    class Call < TwilioObject
      
      @@path = 'Calls'
      @@find_params = [:to,:from,:status,:start_time,:parent_call_sid]
      
      attr_reader :id,:to,:from
      attr_accessor :status,:url, :method
      
      def initialize(params = {})
        
        @options = params
        super
      end
      
      def self.twilify_params(params)
        twilio_params = params.with_indifferent_access
        build_phone_date_param!(twilio_params)
        twilio_params = super(twilio_params)
        
      end
      
      def self.build_phone_date_param!(twilio_params)
        if !(date_keys = %w(started_before started_after started_on_or_before started_on_or_after) & twilio_params.keys).empty?
          
          date_keys.each do | date_key |
            self.twilify_time_key :start_time,date_key,twilio_params[date_key] do | start_time |
              twilio_params[:start_time] = start_time
          end
        end
        twilio_params
      end
    end

end