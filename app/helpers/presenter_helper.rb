module PresenterHelper
  def present(object, presenter_class = nil, &)
    if object.respond_to?(:each)
      CollectionPresenter.new(object, presenter_class, &)
    else
      presenter_class.new(object)
    end
  end
end
