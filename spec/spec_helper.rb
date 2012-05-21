require 'rubygems'
require 'bundler'
require 'rails/all'

Bundler.require :default, :development

require 'rspec/rails'
require 'factory_girl'
require 'ffaker'

# Load factories from spec/factories
Dir[File.expand_path("../factories/*.rb", __FILE__)].each {|factory| require factory }

Combustion.initialize!

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end

# Cloudfuji::Platform.on_cloudfuji? is false,
# so we need to enable it manually
Errbit::Cloudfuji.enable_cloudfuji!
