module Twilio

    class Call < TwilioObject
      
      @@path = 'Calls'
      @@find_params = [:to,:from,:status,:start_time,:parent_call_sid]
      
      #       sid - A 34 character string that uniquely identifies this resource.
      #       parent_call_sid - A 34 character string that uniquely identifies the call that created this leg.
      #       date_created  - The date that this resource was created, given as GMT in RFC 2822 format.
      #       date_updated  - The date that this resource was last updated, given as GMT in RFC 2822 format.
      #       account_sid - The unique id of the Account responsible for creating this call.
      #       to  - The phone number, SIP address or Client identifier that received this call. Phone numbers are in E.164 format (e.g. +16175551212). SIP addresses are formated as name@company.com. Client identifiers are formatted client:name.
      #       from  - The phone number, SIP address or Client identifier that made this call. Phone numbers are in E.164 format (e.g. +16175551212). SIP addresses are formated as name@company.com. Client identifiers are formatted client:name.
      #       phone_number_sid  - If the call was inbound, this is the Sid of the IncomingPhoneNumber that received the call. If the call was outbound, it is the Sid of the OutgoingCallerId from which the call was placed.
      #       status  - A string representing the status of the call. May be queued, ringing, in-progress, canceled, completed, failed, busy or no-answer. See 'Call Status Values' below for more information.
      #       start_time  - The start time of the call, given as GMT in RFC 2822 format. Empty if the call has not yet been dialed.
      #       end_time  - The end time of the call, given as GMT in RFC 2822 format. Empty if the call did not complete successfully.
      #       duration  - The length of the call in seconds. This value is empty for busy, failed, unanswered or ongoing calls.
      #       price - The charge for this call, in the currency associated with the account. Populated after the call is completed. May not be immediately available.
      #       price_unit  - The currency in which Price is measured, in ISO 4127 format (e.g. usd, eur, jpy).
      #       direction - A string describing the direction of the call. inbound for inbound calls, outbound-api for calls initiated via the REST API or outbound-dial for calls initiated by a <Dial> verb.
      #       answered_by - If this call was initiated with answering machine detection, either human or machine. Empty otherwise.
      #       forwarded_from  - If this call was an incoming call forwarded from another number, the forwarding phone number (depends on carrier supporting forwarding). Empty otherwise.
      #       caller_name - If this call was an incoming call to a phone number with Caller ID Lookup enabled, the caller's name. Empty otherwise.
      #       uri - The URI for this resource, relative to https://api.twilio.com
      
      attr_reader :sid,:parent_call_sid,:date_created,:date_updated,:account_sid,:to,:from,:phone_number_sid,
                  :start_time,:end_time,:duration,:price,:price_unit,:direction,:answered_by,:forwarded_from,:caller_name,:uri
      
      attr_accessor :status,:url, :method
      
      def initialize(params = {})
        @options = params
        super(options)
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
        end
        twilio_params
      end
    end

end