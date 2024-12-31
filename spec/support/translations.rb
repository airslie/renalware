module TranslationsHelper
  def with_translations(locale, translations)
    original_backend = I18n.backend

    I18n.backend = I18n::Backend::KeyValue.new({}, true)
    I18n.backend.store_translations(locale, translations)

    yield
  ensure
    I18n.backend = original_backend
  end
end
