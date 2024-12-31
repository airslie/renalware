class TrueClassPresenter < SimpleDelegator
  def to_s
    # rubocop:disable Lint/BooleanSymbol
    I18n.t :true
    # rubocop:enable Lint/BooleanSymbol
  end
end
