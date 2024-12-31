class FalseClassPresenter < SimpleDelegator
  def to_s
    # rubocop:disable Lint/BooleanSymbol
    I18n.t :false
    # rubocop:enable Lint/BooleanSymbol
  end
end
