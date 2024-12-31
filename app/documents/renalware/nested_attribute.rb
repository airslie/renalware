module Renalware
  class NestedAttribute < Document::Embedded
    def nested_attribute?
      true
    end

    def to_partial_path
      class_name = self.class.name.demodulize.underscore
      "renalware/shared/documents/#{class_name}"
    end
  end
end
