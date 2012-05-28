class CloudfujiNoticeObserver < Mongoid::Observer
  observe :notice

  def after_create(notice)
    if ::Cloudfuji::Platform.on_cloudfuji?
      @notice = notice
      @err    = notice.err
      @app    = notice.problem.app

      err_url = Rails.application.routes.url_helpers.app_err_url(@app, @err, :host => ENV['CLOUDFUJI_DOMAIN'])

      human_message = notice_title(notice.err.problem)
      human_message += " - see more at #{err_url}"
      event = {
        :category => :error,
        :name     => :caught,
        :data     => {
          :human            => human_message,
          :error_ido_id     => @err.ido_id,
          :app_name         => @app.name,
          :environment_name => @notice.environment_name,
          :occurrences      => @notice.problem.notices_count,
          :message          => @notice.message,
          :app_backtrace    => @notice.app_backtrace,
          :request          => @notice.request,
          :source           => "Errbit",
          :url              => err_url
        }
      }

      if @notice.respond_to?(:user_attributes) && @notice.user_attributes.present?
        event[:data].merge! {
          :user_attributes => {
            :ido_id => @notice.user_attributes[:ido_id],
            :email  => @notice.user_attributes[:email]
          }
        }
      end

      ::Cloudfuji::Event.publish(event)

      puts "Notifying: #{@app.watchers.inspect}"
      @app.watchers.each do |watcher|
        ido_id = watcher.user.ido_id
        Cloudfuji::User.notify(ido_id, "Site Error", human_message, "site_error") unless ido_id.blank?
      end
    end
  end

  private

  def notice_title(notice)
    "[#{@app.name}][#{@notice.environment_name}] #{@notice.message}"
  end
end

