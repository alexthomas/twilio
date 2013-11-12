module Twilio
  class Engine < ::Rails::Engine
    isolate_namespace Twilio
    
    initializer "accountable.load_app_instance_data" do |app|
      Twilio.setup do |config|
        config.app_root = app.root
        # config.twilio_account_sid = ''
        # config.twilio_auth_token = ''
        # config.twilio_app_id = ''
        # config.twilio_phone_number = '';
        # config.twilio_test_number = '';
        
      end
    end
    
  end
end
