# frozen_string_literal: true

module Renalware
  module ResearchHelper
    def path_to_research_document_form_partial(namespace, type = nil)
      return if namespace.blank?

      partial_path = "studies/#{namespace&.underscore}/#{type}/form"
      partial_path&.gsub("::", "/")&.gsub("//", "/")&.gsub("//", "/")
    end
  end
end
