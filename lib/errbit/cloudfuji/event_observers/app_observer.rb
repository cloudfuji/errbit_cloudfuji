module Errbit
  module Cloudfuji
    module EventObservers
      class AppObserver < ::Cloudfuji::EventObserver
        def app_claimed
          puts "Updating #{User.first.inspect} with incoming data #{params.inspect}"
          puts "Devise username column: #{::Devise.cas_username_column}="
          puts "Setting username to: #{params.try(:[], 'ido_id')}"

          user = User.first
          user.email = params['data'].try(:[], 'email')
          user.name = user.email.split('@').first
          user.send("#{::Devise.cas_username_column}=".to_sym, params['data'].try(:[], 'ido_id'))
          user.save
        end
      end
    end
  end
end
