module Errbit
  module Cloudfuji
    class << self
      def enable_cloudfuji!
        load_hooks!
        extend_user!
        extend_notice!
        disable_devise_for_cloudfuji_controllers!
      end

      def extend_user!
        puts "Extending the user model"
        User.instance_eval do
          validates_presence_of   :ido_id
          validates_uniqueness_of :ido_id
        end

        User.class_eval do
          def cloudfuji_extra_attributes(extra_attributes)
            self.name  = "#{extra_attributes['first_name'].to_s} #{extra_attributes['last_name'].to_s}"
            self.email = extra_attributes["email"]
            self.admin = true
          end
        end
      end

      def extend_notice!
        Notice.class_eval do
          def publish_cloudfuji_event
            human_message = "App at #{server_environment['hostname']} error"
            ::Cloudfuji::Event.publish({
                :category => :app,
                :name     => :error,
                :data     => {
                  :human  => human_message,
                  :source => "Errbit",
                  :url    => "#{ENV['PUBLIC_URL']}/#tickets/#{self.to_param}"
                }
              })
          end
        end
      end

      def load_hooks!
        Dir["#{Dir.pwd}/lib/cloudfuji/**/*.rb"].each { |file| require file }
      end

      # Temporary hack because all routes require authentication in
      # Errbit
      def disable_devise_for_cloudfuji_controllers!
        puts "Disabling devise auth protection on cloudfuji controllers"

        ::Cloudfuji::DataController.instance_eval { before_filter :authenticate_user!, :except => [:index]  }
        ::Cloudfuji::EnvsController.instance_eval { before_filter :authenticate_user!, :except => [:update] }
        ::Cloudfuji::MailController.instance_eval { before_filter :authenticate_user!, :except => [:index]  }

        puts "Devise checks disabled for Cloudfuji controllers"
      end
    end
  end
end

if Cloudfuji::Platform.on_cloudfuji?
  class CloudfujiRailtie < Rails::Railtie
    config.to_prepare do
      puts "Enabling Cloudfuji"
      Errbit::Cloudfuji.enable_cloudfuji!
      puts "Finished enabling Cloudfuji"
    end
  end
end
