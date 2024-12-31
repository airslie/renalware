module Document
  class Enum
    def self.default_enums(model_name, attribute_name)
      I18n.t(attribute_name, scope: "enumerize.#{model_name.i18n_key}", cascade: true).keys
    end

    def to_snomed
      # noop
    end
  end
end
