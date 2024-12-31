class DatePresenter < SimpleDelegator
  def to_s
    ::I18n.l self
  end
end
