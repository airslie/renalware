# frozen_string_literal: true

require "renalware/research"

module MyStudy
  #
  # See comments in engine app/models/renalware/research/study.rb
  #
  class Study < Renalware::Research::Study
    class Document < ::Document::Embedded
      attribute :some_attribute
      validates :some_attribute, presence: true
    end
    has_document
  end
end
