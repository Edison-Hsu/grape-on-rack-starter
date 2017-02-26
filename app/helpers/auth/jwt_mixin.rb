module Auth
  module JwtMixin
    def self.included(base) 
      extend JwtHelpers

      validate_secret_presence

      base.helpers JwtHelpers

      base.helpers do
        def warden
          env['warden']
        end

        def current_user
          warden.user
        end
      end

      base.use Warden::Manager do |manager|
        manager.default_strategies :jwt
        manager.failure_app = lambda do |env|
          raise V1::Errors::NotAuthorizedError
        end
      end

      Warden::Strategies.add(:jwt) do
        def valid?
          request.env['HTTP_AUTHORIZATION'].present?
        end

        def authenticate!
          token = request.env['HTTP_AUTHORIZATION']
          payload = Auth::JwtMixin.decode_payload(token)
          user_id = payload["user_id"]
          user = User.find_by(id: user_id)
          user.nil?  ? fail!('Unauthorized') : success!(user)
        rescue Exception => e
          fail!(e.message)
        end
      end

    end
  end
end
