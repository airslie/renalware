# frozen_string_literal: true

require "renalware/research"

module MyStudy
  #
  #  See comments in engine app/models/renalware/research/study.rb
  #
  class Investigatorship < Renalware::Research::Investigatorship
    class Document < ::Document::Embedded
      attribute :some_attribute, Integer
      validates :some_attribute, presence: true, numericality: true
    end
    has_document
  end
end
