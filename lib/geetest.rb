require 'net/http'
require 'uri'
require 'digest'

class Geetest
  # Parameters name
  FN_CHALLENGE = "geetest_challenge".freeze
  FN_VALIDATE = "geetest_validate".freeze
  FN_SECCODE = "geetest_seccode".freeze

  GT_STATUS_SESSION_KEY = "gt_server_status".freeze
  
  # API
  API_URL = "http://api.geetest.com".freeze
  REGISTER_HANDLER = "/register.php".freeze
  VALIDATE_HANDLER = "/validate.php".freeze

  def initialize(id, key)
    @id = id
    @key = key
  end

  def pre_process(user_id = nil)
    status, challenge = register(user_id)
    make_response_format(challenge, status)
  end

  # 正常模式的二次验证方式.向geetest server 请求验证结果
  def success_validate(challenge, validate, seccode)
    return false if !check_result(challenge, validate)
    info = request_validate(challenge, validate, seccode)
    info == Digest::MD5.hexdigest(seccode)
  end

  def failback_validate(challenge, validate, seccode)
  end

  private
  def http_get(uri)
    request = Net::HTTP::Get.new uri

    yield request if block_given?

    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request request 
    end
  end

  def http_post(uri)
    request = Net::HTTP::Post.new uri

    yield request if block_given?

    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request request 
    end
  end

  def request_register(user_id = nil)
    uri = URI(API_URL + REGISTER_HANDLER)
    uri.query = URI.encode_www_form( gt: @id, user_id: user_id )
    resp = http_get(uri)
    resp.code.to_i == 200 ? resp.body : ""
  end

  def register(user_id = nil) 
    challenge = request_register(user_id)
    if !challenge.empty?
      md5 = Digest::MD5.hexdigest(challenge+@key)
      return 1, md5
    else
      # TODO _make_fail_challenge
    end
  end

  def make_response_format(challenge, status = 1)
    {'success': status, 'gt':@id, 'challenge': challenge}
  end

  def check_result(origin,validate)
    encode = Digest::MD5.hexdigest(@key + "geetest" + origin)
    validate == encode 
  end

  def request_validate(challenge, validate, seccode)
    params = {
      seccode: seccode,
      sdk: 'ruby_3.2.0',
      timestamp: Time.now.to_i,
      challenge: challenge
    }

    uri = URI(API_URL + VALIDATE_HANDLER)

    resp = http_post(uri) do |req|
      req.set_form_data(params)
    end
    
    resp.code.to_i == 200 ? resp.body : ''
  end

end
