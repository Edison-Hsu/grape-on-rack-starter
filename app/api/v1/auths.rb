class V1
  class Auths < Grape::API
    helpers YunpianHelpers
    helpers ::AuthHelpers

    helpers do
      def current_geetest(channel)
        geetest = ENV['GEETEST_INSTANCE'] || begin
          id = ENV['GEETEST_PC_ID']
          key = ENV['GEETEST_PC_KEY']
          if channel == 'ios'
            id = ENV['GEETEST_IOS_ID']
            key = ENV['GEETEST_IOS_KEY']
          end
          geetest = Geetest.new(id, key)
        end
      end
    end

    class TokenEntity < Grape::Entity
      expose :access_token
      expose :user_id
    end

    resource 'auth' do
      desc '-----get capcha------'
      params do
        optional :channel,
                 type: String,
                 values: %w(ios web),
                 default: 'web'
      end
      get 'capcha/register' do
        current_geetest(params[:channel]).pre_process
      end

      desc '-------send sms code----------'
      params do
        requires :phone,
                 type: String,
                 desc: 'phone number'
        requires :channel,
                 type: String,
                 values: ['web', 'ios'],
                 desc: 'channel'
        requires :action,
                 type: String,
                 values: ['register', 'reset']
        optional :geetest_challenge,
                 type: String,
                 desc: 'geetest_challenge'
        optional :geetest_validate,
                 type: String,
                 desc: 'geetest_validate'
        optional :geetest_seccode,
                 type: String,
                 desc: 'geetest_seccode'
      end
      post 'sms/code' do
        # raise Errors::SmsValidateFailedError if !current_geetest(params[:channel]).success_validate(params[:geetest_challenge], params[:geetest_validate], params[:geetest_seccode])
        send_sms(params)
      end

      desc '--------login with phone number--------'
      params do
        requires :password,
                 type: String,
                 desc: 'user password',
                 regexp: /.+{6,64}/
        requires :phone,
                 type: String,
                 desc: 'phone number'
      end
      post 'login/phone' do
        user = User.find_by(phone: params[:phone])
        if user.nil? || user.password != params[:password]
          raise Errors::UsernameOrPasswordError
        end
        token = build_user_token(user.id)
        present token, with: TokenEntity
      end

      desc '-------register with sms code and mobile'
      params do
        requires :username,
                 type: String,
                 regexp: /.+{6,32}/
        requires :password,
                 type: String,
                 regexp: /.+{6,64}/
        requires :phone,
                 type: String,
                 desc: 'phone number'
        requires :code,
                 type: String
        optional :email, type: String
        optional :nickname, type: String
        optional :avatar_url, type: String
        optional :city, type: String
      end
      post 'register/phone' do
        raise Errors::PhoneDuplicationRegisterError if User.exists?(phone: params[:phone])
        verify_sms!(params)
        user = User.create_account(params)
        token = build_user_token(user.id)
        present token, with: TokenEntity
      end

      desc '-------reset password with sms code and mobile'
      params do
        requires :phone,
                 type: String,
                 desc: 'phone number'
        requires :code,
                 type: String
        requires :password,
                 type: String
      end
      post 'password/reset' do
        verify_sms!(params)
        user = User.find_by(phone: params[:phone])
        user.password = params[:password]
        token = build_user_token(user.id)
        present token, with: TokenEntity
      end

      desc '--------logout---------'
      post 'logout' do
        { message: 'OK' }
      end
    end
  end
end
