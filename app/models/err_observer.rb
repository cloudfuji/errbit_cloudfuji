class ErrObserver < Mongoid::Observer
  def after_create(err)
    if ::Cloudfuji::Platform.on_cloudfuji?
      human_message = issue_title(err.problem)
      human_message += " see more at #{Rails.application.routes.url_helpers.app_err_url(err.problem.app, err, :host => ENV['CLOUDFUJI_DOMAIN'])}"
      event = {
        :category => :app,
        :name     => :errored,
        :data     => {
          :human  => human_message,
          :source => "Errbit",
          :url    => Rails.application.routes.url_helpers.app_err_url(err.problem.app, err, :host => ENV['CLOUDFUJI_DOMAIN'])
        }
      }
      ::Cloudfuji::Event.publish(event)
    end
  end

  def issue_title(problem)
    "[#{ problem.environment }][#{ problem.where }] #{problem.message.to_s.truncate(100)}"
  end
end
