require 'errbit/cloudfuji'

Errbit::Application.configure do
  # Register observers to fire Cloudfuji events
  (config.mongoid.observers ||= []) << :cloudfuji_notice_observer

  # Set default host for ActionMailer
  default_host = ENV['ERRBIT_HOST'] || ENV['BUSHIDO_DOMAIN']
  config.action_mailer.default_url_options = { :host => default_host } if default_host
end
