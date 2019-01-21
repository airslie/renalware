# frozen_string_literal: true

require "renalware/research"

module MyStudy
  class Investigatorship < Renalware::Research::Investigatorship
    # Augment the base Document by adding some fields...
    class Document < Renalware::Research::Investigatorship::Document
      attribute :some_attribute, Integer
      validates :some_attribute, presence: true, numericality: true
    end
    has_document
  end
end
