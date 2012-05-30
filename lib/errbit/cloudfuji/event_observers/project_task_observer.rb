module Errbit
  module Cloudfuji
    module EventObservers
      class ProjectTaskObserver < ::Cloudfuji::EventObserver

        def project_task_created
          data = params['data']
          # Find error with matching ido_id
          if err = Err.where(:ido_id => data['ido_id']).first
            # Update issue link on error with task url
            if data['url'] && err.problem.issue_link != data['url']
              err.problem.update_attribute :issue_link, data['url']
            end

            # If task state is 'accepted', then resolve the error
            if data['state'] == 'accepted'
              err.problem.resolve!
            end
          end
        end
        # Use same method for task create and update
        alias :project_task_updated :project_task_created

      end
    end
  end
end
