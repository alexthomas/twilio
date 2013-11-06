module Twilio
  class TestController < ApplicationController
    
    def index
      @params = Twilio::Message.find_by({
        :from => '3243028423042',
        'To' => 'eiejoejdoef',
        :sent_on_or_before => 'date'
      })
      Rails.logger.debug "params in test controller index = #{@params}"
      # @response = Twilio::Message.create(
      #   :from => Twilio.twilio_phone_number,
      #   :to => Twilio.twilio_test_number,
      #   :body => 'Hey there Ems, Love Alf xxxxx'
      # )
    end
    
  end
end
