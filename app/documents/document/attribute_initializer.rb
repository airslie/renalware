module Document
  module AttributeInitializer
    def self.determine_initializer(klass, name, type, options)
      initializer_class = build_class(type)
      initializer_class.new(klass, name, type, options)
    end

    def self.build_class(type)
      if type == Document::Enum
        AttributeInitializer::Enum
      elsif type&.included_modules&.include?(::ActiveModel::Model)
        AttributeInitializer::ActiveModel
      else
        AttributeInitializer::Base
      end
    end

    private_class_method :build_class
  end
end
