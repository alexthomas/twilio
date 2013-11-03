module Twilio
  class TestController < ApplicationController
    
    def index
      @response = Twilio.get('messages',{})
    end
    
  end
end
