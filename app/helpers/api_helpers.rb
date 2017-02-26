module ApiHelpers
  extend Grape::API::Helpers

  Grape::Entity.format_with :safe_string do |date|
    date.to_s
  end
end
