module CoreExtensions
  module I18n
    module HandleBlankValue
      def localize(object, locale: nil, format: nil, **options)
        object.blank? ? "" : super
      end
      alias l localize
    end
  end
end
