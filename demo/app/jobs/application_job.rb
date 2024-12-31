class ApplicationJob < ActiveJob::Base
  rescue_from StandardError do |exception|
    begin
      # custom handling
    rescue StandardError => e
      Rails.logger.error(e)
      nil
    end
    raise exception
  end
end
