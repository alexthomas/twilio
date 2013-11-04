module Twilio
  class TestController < ApplicationController
    
    def index
      @response = Twilio::Message.create(
        :from => Twilio.twilio_phone_number,
        :to => Twilio.twilio_test_number,
        :body => 'Hey there Ems, Love Alf xxxxx'
      )
    end
    
  end
end
