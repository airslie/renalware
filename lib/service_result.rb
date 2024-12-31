class ServiceResult
  attr_reader :object

  def initialize(object)
    @object = object
  end

  def success?
    false
  end

  def failure?
    !success?
  end
end
