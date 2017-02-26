require 'net/http'

module NetHelpers
  def get_https(url)
    uri = URI(url)
    request = Net::HTTP::Get.new uri

    yield request if block_given?

    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      response = http.request request # Net::HTTPResponse object
      JSON.parse(response.body)
    end
  end

  def post_https(url, params = nil)
    uri = URI(url)
    request = Net::HTTP::Post.new uri

    yield request if block_given?

    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request.set_form_data(params) if params
      response = http.request request # Net::HTTPResponse object
      json = JSON.parse(response.body)
      ActiveRecord::Base.logger.info json
      json
    end
  end

  def encodeURIComponent(uri)
    URI.escape(uri, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end

end
