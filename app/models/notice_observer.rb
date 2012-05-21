class NoticeObserver < Mongoid::Observer
  def after_create(notice)
    if ::Cloudfuji::Platform.on_cloudfuji?
      @notice = notice
      @err    = notice.err
      @app    = notice.problem.app

      human_message = notice_title(notice.err.problem)
      human_message += " see more at #{Rails.application.routes.url_helpers.app_err_url(@app, @notice.problem, :host => ENV['CLOUDFUJI_DOMAIN'])}"
      event = {
        :category => :app,
        :name     => :errored,
        :data     => {
          :human  => human_message,
          :environment_name => @notice.environment_name,
          :occurrences      => @notice.problem.notices_count,
          :message          => @notice.message,
          :app_backtrace    => @notice.app_backtrace,
          :request          => @notice.request,
          :source           => "Errbit",
          :url              => Rails.application.routes.url_helpers.app_err_url(@app, @err, :host => ENV['CLOUDFUJI_DOMAIN'])
        }
      }

      ::Cloudfuji::Event.publish(event)

      puts "Notifying: #{@app.watchers.inspect}"
      @app.watchers.each do |watcher|
        ido_id = watcher.user.ido_id
        Cloudfuji::User.notify(ido_id, "Site Error", human_message, "site_error") unless ido_id.blank?
      end
    end
  end

  def notice_title(notice)
    "[#{@app.name}][#{@notice.environment_name}] #{@notice.message}"
  end
end
