module Twilio
  class TestController < ApplicationController
    
    def index
      # @response = Twilio::Message.find_by({
      #         :from => '3243028423042',
      #         'To' => 'eiejoejdoef',
      #         'Badger' => 'eiejoejdoef',
      #         :sent_on_or_before => 'date'
      #       })
      
      # @twiml = Twilio::TwiML.build do |res|
      #         res.say    'Hey man! Listen to this!', :voice => 'man'
      #         res.play   'http://foo.com/cowbell.mp3', :loop => 3
      #         res.say    'What did you think of that?!', :voice => 'man'
      #         res.record :action => 'http://foo.com/handleRecording',
      #                    :method => 'GET', :max_length => '20',
      #                    :finish_on_Key => '*'
      #         res.gather :action => '/process_gather', :method => 'GET' do |g|
      #           g.say 'Now hit some buttons!'
      #         end
      #         res.say    'Awesome! Thanks!', :voice => 'man'
      #         res.hangup
      #       end
      # @call = Twilio::Call.create({
      #         :from => "+15005550006",
      #         :to => Twilio.twilio_test_number,
      #         :url => "http://demo.twilio.com/docs/voice.xml",
      #         :badgers => 'like unicorns'
      #       })
      @capability = Twilio::CapabilityToken.create \
        account_sid:    'AC00000000000000000000000',
        auth_token:     'XXXXXXXXXXXXXXXXXXXXXXXXX',
        allow_incoming: 'unique_identifier_for_this_user',
        allow_outgoing: 'your_application_sid'
    end
    
  end
end
