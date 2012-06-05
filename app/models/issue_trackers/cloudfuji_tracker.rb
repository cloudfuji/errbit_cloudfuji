module IssueTrackers
  class CloudfujiTracker < ::IssueTracker
    Label = "cloudfuji"
    Fields = [
      [:project_id, {
        :label       => "Project Ido ID",
        :placeholder => "Ido ID of project to create task on"
      }]
    ]

    def check_params
      if Fields.detect {|f| self[f[0]].blank? }
        errors.add :base, 'You must specify your Project Ido ID'
      end
    end

    def create_issue(problem, reported_by)
      if ::Cloudfuji::Platform.on_cloudfuji?
        err = problem.errs.last

        event = {
          :category => :project_task,
          :name     => :created,
          :data     => {
            :ido_id          => err.ido_id,
            :title           => issue_title(problem),
            :description     => body_template.result(binding),
            :task_type       => 'bug',
            :state           => 'unscheduled',
            :requested_by_id => reported_by.ido_id,
            :project_id      => project_id,
            :labels          => "errbit"
          }
        }

        puts "Publishing Cloudfuji Event: #{event.inspect}"

        ::Cloudfuji::Event.publish(event)

        # Display 'pending' message until tracker responds with url
        problem.update_attributes(
          :issue_link => "pending",
          :issue_type => Label
        )
      end
    end

    def body_template
      @@body_template ||= ERB.new(File.read(File.expand_path("../../../views/issue_trackers/cloudfuji_body.txt.erb", __FILE__)).gsub(/^\s*/, ''))
    end

    def url
      "http://cloudfuji.com"
    end
  end
end
