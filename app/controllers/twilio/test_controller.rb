module Twilio
  class TestController < ApplicationController
    
    def index
      @response = Twilio::Message.find_by({
        :from => '3243028423042',
        'To' => 'eiejoejdoef',
        :sent_on_or_before => 'date'
      })
    end
    
  end
end
