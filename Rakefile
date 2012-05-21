#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
Bundler.require :default, :development

task :environment do
  Combustion.initialize!
end
Combustion::Application.load_tasks

class Combustion::Application
  # Add migrations from all engines
  Railties.engines.each do |engine|
    config.paths['db/migrate'] += engine.paths['db/migrate'].existent
  end
end

desc 'Default: run spec tests.'
task :default => :spec

# Let Combustion handle database preparation
Rake::Task["spec"].prerequisites.clear

Bundler::GemHelper.install_tasks
