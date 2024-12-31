class StringPresenter
  include ::ActionView::Helpers::TextHelper

  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end
end
