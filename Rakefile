require 'active_record_migrations'

ActiveRecordMigrations.configure do |c|
  c.yaml_config = 'config/database.yml'
end
ActiveRecordMigrations.load_tasks

namespace :app do
  desc 'generate jwt secret'
  task :gen_jwt_secret do
    require 'SecureRandom'
    p SecureRandom.base64(128)
  end
end

namespace :grape do
  desc "Print compiled grape routes"
  task :routes => :preload do
    ::Root.routes.each do |route|
      pp route.options
    end
  end
end
