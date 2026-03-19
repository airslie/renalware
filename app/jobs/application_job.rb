class ApplicationJob < ActiveJob::Base
  rescue_from StandardError do |exception|
    Rails.error.report(
      exception,
      handled: false,
      source: "application.active_job",
      context: {
        job: self.class.name || self.class.to_s,
        queue_name: queue_name,
        job_id: job_id
      }
    )

    raise
  end
end
