require 'active_record'
require 'yaml'
require 'erb'
require 'logger'

task default: [:spec]
begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  nil
end

desc 'Migrate database'
task migrate: :environment do
  ActiveRecord::Migrator.migrate('db/migrate', ENV['VERSION'] ? ENV['VERSION'].to_i : nil)
end

task :environment do
  dbconfig = YAML.load File.read 'config/database.yml'
  ActiveRecord::Base.establish_connection(dbconfig)
  ActiveRecord::Base.logger = Logger.new(STDERR)
end
