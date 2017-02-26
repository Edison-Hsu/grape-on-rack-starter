class Root < Grape::API
  format :json

  use Grape::Middleware::Logger, {
    logger: ActiveRecord::Base.logger
  }

  Root.rescue_from Grape::Exceptions::ValidationErrors do |e|
    error!({ code: 40_000, message: e.message }, 400)
  end

  Root.rescue_from ::V1::Errors::NotAuthorizedError do |e|
    error!({ code: e.code, message: e.message }, 401)
  end

  Root.rescue_from ::V1::Errors::ApiError do |e|
    error!({ code: e.code, message: e.message }, 403)
  end

  mount ::V1
  mount ::Test::Test

end
