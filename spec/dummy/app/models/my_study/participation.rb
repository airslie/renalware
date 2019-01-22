# frozen_string_literal: true

require "renalware/research"

module MyStudy
  #
  # See comments in engine app/models/renalware/research/study.rb
  #
  class Participation < Renalware::Research::Participation
    class Document < ::Document::Embedded
      attribute :some_attribute, String
      validates :some_attribute, presence: true
    end
    has_document # important this goes here
  end
end
