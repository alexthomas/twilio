module Twilio
  module CapabilityToken
    def self.create(params={})
      params.stringify_keys!
      account_sid, auth_token = *capability_credentials(params)
      payload = {
        :exp   => (params.delete('expires') || 1.hour.from_now).to_i,
        :scope => params.map { |k,v| self.respond_to?(k) ? send(k, v, params) : next }.join(' '),
        :iss   => account_sid
      }
      JWT.encode(payload,auth_token)
    end

    private

    def self.capability_credentials(params)
      if params['account_sid'] && params['auth_token']
        [params['account_sid'], params['auth_token']]
      else
        [Twilio.twilio_account_sid, Twilio.twilio_auth_token]
      end
    end

    def self.allow_incoming(client_id, params)
      token_for 'client', 'incoming', { 'clientName' => client_id }
    end

    def self.allow_outgoing(payload, params)
      p = {}
      if payload.respond_to? :each
        p['appSid']    = payload.shift
        p['appParams'] = uri_encode payload.pop
      else # it's a string
        p['appSid'] = payload
      end
      p['clientName'] = params['allow_incoming'] if params['allow_incoming']
      token_for 'client', 'outgoing', p
    end
    
    def self.token_for(service, privilege, params = {})
      token = "scope:#{service}:#{privilege}"
      token << "#{Twilio.encode_uri_get_params params}" if params.any?
    end

  end
end