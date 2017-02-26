class User < ApplicationRecord
  include BCrypt

  has_many :social_accounts

  # MARK - bcrypt password
  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
    self.save
  end

  class << self
    def filter(attrs, allow_keys)
      attrs.to_h.select! {|k,v| allow_keys.include?(k) && v != nil }
    end

    def create_account(attrs)
      params = filter(attrs, ['phone', 'username', 'password', 'email'])
      profile = filter(attrs, ['nickname', 'avatar_url', 'city', 'introduce']) 
      
      create(params.merge(profile: profile))
    end
  end
end
