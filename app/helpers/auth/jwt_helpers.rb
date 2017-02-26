module Auth
  module JwtHelpers

    def decode_payload(token)
      jwt = JWT.decode token, ENV['JWT_SECRET'], true, {:algorithm => 'HS256'}
      jwt[0] # get payload
    end
    
    def encode_payload(payload)
      validate_secret_presence

      JWT.encode payload, ENV['JWT_SECRET'], 'HS256'
    end

    def validate_secret_presence
      fail 'You must set ENV["JWT_SECRET"]' unless ENV['JWT_SECRET']
    end
  end
end
