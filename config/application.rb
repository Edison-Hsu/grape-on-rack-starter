require File.expand_path('../boot', __FILE__)
require 'active_record'
require 'logger'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, ENV['RACK_ENV'])

# initialize log

Dir.mkdir('log') unless File.exist?('log')
class ::Logger; alias_method :write, :<<; end
case ENV["RACK_ENV"]
when "production"
  logger = ::Logger.new("log/production.log")
  logger.level = ::Logger::INFO
when "development"
  logger = ::Logger.new(STDOUT)
  logger.level = ::Logger::DEBUG
else
  logger = ::Logger.new("/dev/null")
end

# Auto load file by rails way
ActiveSupport::Dependencies.autoload_paths << File.expand_path("app/api")
ActiveSupport::Dependencies.autoload_paths << File.expand_path("app/helpers")
ActiveSupport::Dependencies.autoload_paths << File.expand_path("app/models")
ActiveSupport::Dependencies.autoload_paths << File.expand_path("lib")

# cache
# redis_yaml = YAML::load(File.open('config/redis.yml'))[ENV["RACK_ENV"]]
# redis = Redis.new(url: redis_yaml["url"], driver: :hiredis)
# api_redis = Redis::Namespace.new(:api, redis: redis)
# ENV["REDIS_EXPIRES_TIME"] = redis_yaml["expire"].to_s

# Cache::Service.config do |c|
#   c.cache_store = api_redis
#   c.logger = logger
# end


# initialize ActiveRecord
ActiveRecord::Base.establish_connection YAML::load(File.open('config/database.yml'))[ENV["RACK_ENV"]]
# ActiveRecord::Base.logger = logger
ActiveSupport.on_load(:active_record) do
  self.include_root_in_json = false
  self.default_timezone = :local
  self.time_zone_aware_attributes = false
  self.logger = logger
  ActiveRecord::QueryCache.install_executor_hooks
  ActiveSupport::Reloader.before_class_unload do
    if ActiveRecord::Base.connected?
      ActiveRecord::Base.clear_cache!
      ActiveRecord::Base.clear_reloadable_connections!
    end
  end
end

# TODO auto load all yml files and write to env
yunpian = YAML::load(File.open('config/yunpian.yml'))[ENV["RACK_ENV"]]
ENV["YUNPIAN_API_KEY"] = yunpian["ApiKey"]
ENV["SMS_CODE_EXPIRES_IN"] = yunpian["CodeExpiresIn"].to_s

yaml = YAML::load(File.open('config/jwt_secrets.yml'))[ENV["RACK_ENV"]]
ENV["JWT_SECRET"] = yaml["secret"]

# # paperclip - upyun
# require_relative '../lib/paperclip/storage/upyun'
# Paperclip::Attachment.default_options[:storage] = :upyun
# Paperclip::Attachment.default_options[:bucket] = ENV["UPYUN_BUCKET"]
# Paperclip::Attachment.default_options[:operator] = ENV["UPYUN_OPERATOR"]
# Paperclip::Attachment.default_options[:password] = ENV["UPYUN_PASSWORD"]
# Paperclip::Attachment.default_options[:upyun_host] = ENV["UPYUN_HOST"]
# Paperclip::Attachment.default_options[:use_timestamp] = false
