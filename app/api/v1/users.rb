class V1
  class Users < Grape::API
    include Auth::JwtMixin

    helpers ::AuthHelpers
    helpers YunpianHelpers

    class ProfileEntity < Grape::Entity
      expose :id, as: :user_id
      expose :nickname do |user| user.profile.to_h['nickname'].to_s end
      expose :introduce do |user| user.profile.to_h['introduce'].to_s end
      expose :avatar_url do |user| user.profile.to_h['avatar_url'].to_s end
    end

    # MARK - APIs 
    resource 'users/:user_id' do
      namespace 'password' do

        before do
          warden.authenticate!
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
        patch do
          raise Errors::NotAuthorizedError if current_user.id != params[:user_id]
          raise Errors::PhoneNumberNotMatchError if current_user.phone != params[:phone]
          verify_sms!(phone: params[:phone], code: params[:code])
          current_user.password = params[:password]
          token = build_user_token(current_user.id)
          present token, with: V1::Auths::TokenEntity
        end
      end

      namespace 'profile' do

        before do
          warden.authenticate!
        end

        desc '------update-profile--------'
        params do
          requires :user_id, type: String, desc: 'user id'
          optional :introduce,
                   type: String,
                   desc: 'self introduce'
          optional :nickname,
                   type: String,
                   desc: 'nickname'
          optional :avatar_url,
                   type: String,
                   desc: 'avatar url'
        end
        put do
          raise Errors::NotAuthorizedError if current_user.id != params[:user_id]
          profile = current_user.profile.to_h.merge(params.to_h)
          current_user.update(profile: profile)
          present current_user, with: ProfileEntity
        end

        desc '------get----profile-------'
        params do
          requires :user_id, type: String, desc: 'user id'
        end
        get do
          # other people can see your profile
          # raise Errors::NotAuthorizedError if current_user.id != params[:user_id]
          user = User.find_by(id: params[:user_id])
          raise Errors::UserIdNotFoundError if user.nil?

          present user, with: ProfileEntity
        end
      end
    end
  end
end
