# Override engine view paths so that this gem's views can override application views
Rails::Engine.initializers.detect{|i| i.name == :add_view_paths }.
  instance_variable_set("@block", Proc.new {
    views = paths["app/views"].to_a
    unless views.empty?
      ActiveSupport.on_load(:action_controller){ append_view_path(views) }
      ActiveSupport.on_load(:action_mailer){ append_view_path(views) }
    end
  }
)

module Errbit
  module Cloudfuji
    class Engine < Rails::Engine
      config.to_prepare do
        Dir[File.expand_path("../../../app/models/issue_trackers/*.rb", __FILE__)].each {|f| require f }
      end
    end
  end
end
