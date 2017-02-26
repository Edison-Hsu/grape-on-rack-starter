require 'active_record'
require 'active_record_migrations'

ActiveRecordMigrations.configure do |c|
  c.yaml_config = 'config/database.yml'
end
ActiveRecordMigrations.load_tasks

task :preload do
  require File.expand_path('config/environment', File.dirname(__FILE__))
  require File.expand_path('app/api/root', File.dirname(__FILE__))
end

namespace :grape do
  desc "Print compiled grape routes"
  task :routes => :preload do
    ::Root.routes.each do |route|
      pp route.options
    end
  end
end
