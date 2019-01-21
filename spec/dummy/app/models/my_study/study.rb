# frozen_string_literal: true

module MyStudy
  class Study < Renalware::Research::Study
    # Augment the base Document by adding some fields...
    class Document < Renalware::Research::Study::Document
      attribute :something
      validates :something, presence: true
    end
    has_document class_name: "Document"
  end
end
