require 'fileutils'

namespace :cloudfuji do

  desc "Copys of example config files"
  task :copy_configs do
    unless File.exist? Rails.root.join('config/mongoid.yml')
      FileUtils.cp File.expand_path("../../../config/mongoid.cloudfuji.yml", __FILE__),
                   Rails.root.join('config/mongoid.yml')
    end
  end

  desc "Run the initial setup for a Busido app. Copies config files and seeds db."
  task :install do
    Rake::Task['cloudfuji:copy_configs'].execute
    puts "\n"
    Rake::Task['db:seed'].invoke
    puts "\n"
    Rake::Task['db:mongoid:create_indexes'].invoke
  end
end

namespace :db do
  desc "Migrate errbit_cloudfuji"
  task :migrate => :environment do
    Mongoid::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    Mongoid::Migrator.migrate(File.expand_path("../../../db/migrate/", __FILE__), ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  end
end
