class TimePresenter < SimpleDelegator
  def to_s
    ::I18n.l self
  end
end
