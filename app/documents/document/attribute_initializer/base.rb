module Document
  module AttributeInitializer
    class Base
      attr_reader :klass, :name, :type, :options

      def initialize(klass, name, type, options)
        @klass = klass
        @name = name
        @type = type
        @options = options
      end

      def call
        yield name, type, options
      end
    end
  end
end
