module Twilio

    class Message < TwilioObject
      
      @@path = 'SMS/Messages'
      @@find_params = [:from,:to,:date_sent]
      
      #       sid - A 34 character string that uniquely identifies this resource.
      #       date_created  - The date that this resource was created, given in RFC 2822 format.
      #       date_updated  - The date that this resource was last updated, given in RFC 2822 format.
      #       date_sent - The date that the message was sent. For incoming messages, this is the date that Twilio received the message. The date is given in RFC 2822 format.
      #       account_sid - The unique id of the Account that sent this message.
      #       from  - The phone number that initiated the message in E.164 format. For incoming messages, this will be the remote phone. For outgoing messages, this will be one of your Twilio phone numbers.
      #       to  - The phone number that received the message in E.164 format. For incoming messages, this will be one of your Twilio phone numbers. For outgoing messages, this will be the remote phone.
      #       body - The text body of the message. Up to 1600 characters long.
      #       num_segments  - This property indicates the number of sms messages used to deliver the body specified. If your body is too large to be sent as a single SMS message, it will be segmented and charged accordingly.
      #       status  - The status of this message. Either queued, sending, sent,failed, or received.
      #       direction - The direction of this message. inbound for incoming messages, outbound-api for messages initiated via the REST API, outbound-call for messages initiated during a call or outbound-reply for messages initiated in response to an incoming message.
      #       price - The amount billed for the message, in the currency associated with the account. Note that your account will be charged for each segment sent to the handset.
      #       price_unit  - The currency in which Price is measured, in ISO 4127 format (e.g. usd, eur, jpy).
      #       api_version - The version of the Twilio API used to process the message.
      #       uri - The URI for this resource, relative to https://api.twilio.com
      
      attr_reader :sid,:date_created,:date_updated,:date_sent,:account_sid,:from,:to,:body,
                          :num_segments,:status,:direction,:price,:price_unit,:api_version,:uri
      
      def initialize(params = {})
        @options = params
        super
      end
      
      def self.twilify_params(params)
        twilio_params = params.with_indifferent_access
        build_twilio_date_param!(twilio_params)
        twilio_params = super(twilio_params)
        
      end
      
      def media
        Twilio.get("#{@path}/media")
      end
      
      def self.build_twilio_date_param!(twilio_params)
        if !(date_keys = %w(sent_before sent_after sent_on_or_before sent_on_or_after) & twilio_params.keys).empty?
          date_key = date_keys.first
          self.twilify_time_key :date_sent,date_key,twilio_params[date_key] do | date_sent |
            twilio_params[:date_sent] = date_sent
          end
          
        end
        twilio_params
      end
    end

end