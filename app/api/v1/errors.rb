class V1
  module Errors 
    Error = Struct.new(:code, :message)

    ERRORS = {
      # Authorized 
      NotAuthorizedError: Error.new( 
        41_000, 
        "Not Authorized"
      ),
      # Users Errors
      AlreadyAddedFriendError: Error.new( 
        42_000, 
        "You already have this friend"
      ),
      FriendIdNotFoundError: Error.new( 
        42_001, 
        "Friend id not found"
      ),
      UserIdNotFoundError: Error.new( 
        42_003, 
        "User id not found"
      ),
      UsernameOrPasswordError: Error.new(
        42_004,
        "username or password is wrong"
      ),
      PhoneDuplicationRegisterError: Error.new(
        42_005,
        "The phone number is already registered"
      ),
      SendSmsCodeFirstError: Error.new(
        42_006,
        "Please send sms code first"
      ),
      SmsCodeWrongOrExpiredError: Error.new(
        42_007,
        "Sms code is wrong or expired"
      ),
      SmsValidateFailedError: Error.new(
        42_008,
        "Sms validate Failed"
      )
    }

    class ApiError < StandardError
      def message
        ERRORS[self.class.to_s.demodulize.to_sym].message
      end

      def code
        ERRORS[self.class.to_s.demodulize.to_sym].code
      end
    end

    ERRORS.each do |key, _|
      self.const_set(key, Class.new(ApiError))
    end
  end
end

