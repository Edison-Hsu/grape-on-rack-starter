module AuthHelpers
  include Auth::JwtHelpers

  def build_user_token(uid)
    user_id = uid
    payload = { user_id: user_id,
                iat: Time.now.to_i,
                sub: 'dive' }
    token = encode_payload(payload)
    { user_id: user_id, access_token: token }
  end
end
