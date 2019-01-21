# frozen_string_literal: true

require "document/base"
require "renalware/research"

class Investigatorship < Renalware::Research::Investigatorship
  class Document < Renalware::Research::Investigatorship::Document
    attribute :yay, String
  end
  has_document class_name: "Document"
end
