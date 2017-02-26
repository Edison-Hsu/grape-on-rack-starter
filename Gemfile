source "https://rubygems.org"

# Ruby web interface
gem 'rack'
gem 'rack-cors', :require => 'rack/cors'
gem "rack-test", require: "rack/test"

gem 'grape'
gem 'grape-entity'
gem 'grape-middleware-logger'

# Add swagger compliant documentation to your grape API
# gem 'grape-swagger'
# gem 'grape-raketasks'

# Easy file attachment management for ActiveRecord
# gem "paperclip", "~> 4.3"

# Paperclip for qiniu
# gem 'paperclip-qiniu'
# gem 'upyun'

# Ruby Makefile
gem 'rake'

# OAuth 2.0 Server & Client Library. Both Bearer and MAC token type are supported.
# gem 'rack-oauth2'

gem 'activerecord', '~>5.0'
gem 'active_record_migrations'
gem 'pg'
gem 'puma'

# gem 'minitest', '~>5.1'
# gem 'builder', '~>3.1'
# gem 'activerecord-postgis-adapter'

# soft delete support in db
gem "paranoia", "~> 2.2"

# password crypt
gem 'bcrypt'

# gem 'rack-mini-profiler'

# Ruby wrapper for hiredis 
# gem "hiredis", "~> 0.6.1"
# gem "redis", ">= 3.2.0", :require => ["redis", "redis/connection/hiredis"]
# gem 'redis-namespace'

# A pure ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard. http://jwt.github.io/ruby-jwt/
gem 'jwt'

# Annotate Rails classes with schema and routes info
# gem 'annotate'
gem 'warden'

group :development do
  # gem 'standalone_migrations'
  gem 'pry'
  gem 'awesome_print'
  gem 'rerun'
  # gem 'pry-doc', :git => 'git@github.com:pry/pry-doc.git'
  gem 'mina', require: false
  gem 'mina-puma', require: false
  gem 'mina-multistage', require: false
end

group :test do
  gem 'rspec'
  gem 'factory_girl'
  # A Ruby static code analyzer, based on the community Ruby style guide.
  gem 'rubocop', require: false
end
