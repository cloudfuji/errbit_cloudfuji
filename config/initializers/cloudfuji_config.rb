if ENV['HOSTING_PLATFORM'] == 'cloudfuji'
  require 'ostruct'
  Errbit::Config = OpenStruct.new

  puts "Loading Cloudfuji config"
  Errbit::Config.host = ENV['CLOUDFUJI_DOMAIN']
  Errbit::Config.email_from = ENV['SMTP_USER']
  Errbit::Config.email_at_notices = [1,3,10] #ENV['ERRBIT_EMAIL_AT_NOTICES']
  Errbit::Config.confirm_resolve_err = true
  Errbit::Config.user_has_ido_id = true
  Errbit::Config.allow_comments_with_issue_tracker = true

  Errbit::Config.smtp_settings = {
    :address        => ENV["SMTP_SERVER"],
    :port           => ENV["SMTP_PORT"],
    :authentication => ENV["SMTP_AUTHENTICATION"],
    :user_name      => ENV["SMTP_USER"],
    :password       => ENV["SMTP_PASSWORD"],
    :domain         => ENV["SMTP_DOMAIN"]
  }

  Errbit::Config.devise_modules = [:cloudfuji_authenticatable,
                                   :rememberable,
                                   :trackable,
                                   :token_authenticatable]

  puts "Devise modules: #{Errbit::Config.devise_modules.inspect}"
end
