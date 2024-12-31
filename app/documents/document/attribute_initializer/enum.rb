module Document
  module AttributeInitializer
    class Enum < Base
      def call
        yield name, type, options
        configure_enums
      end

      private

      # Be sure to pass any enumerize options in to klass.enumerize, for example to support
      # multiple: true which will results in an array of enums stored.
      #
      # Example usage for multiple: true
      #
      #  Class X
      #    attribute :roles, ::Document::Enum, enumerize: { multiple: true }
      #  end
      def configure_enums
        enums = options[:enums] || Document::Enum.default_enums(klass.model_name, name)
        klass.enumerize name, in: enums, **(options[:enumerize] || {})
      end
    end
  end
end
