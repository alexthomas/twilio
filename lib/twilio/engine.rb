module Twilio
  class Engine < ::Rails::Engine
    isolate_namespace Twilio
    
    initializer "accountable.load_app_instance_data" do |app|
      Twilio.setup do |config|
        config.app_root = app.root
        config.twilio_account_sid = 'ACaf0eee667926566569d4ce3c9abc458e'
        config.twilio_auth_token = '2229b2c0a5b6442d7c31a2c1791d6b92'
        config.twilio_app_id = 'AP260515ea3b72ce619a7a4f97d999f172'
        config.twilio_phone_number = '+15005550007';
        config.twilio_test_number = '+61404100419';
        
      end
    end
    
  end
end
