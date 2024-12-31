require "service_result"

class Success < ServiceResult
  def success?
    true
  end
end
