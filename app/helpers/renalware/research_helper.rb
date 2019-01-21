# frozen_string_literal: true

module Renalware
  module ResearchHelper
    def partial_path_from_namespace(namespace, type = nil)
      return if namespace.blank?

      partial_path = "studies/#{namespace&.underscore}/#{type}/form"
      partial_path&.gsub("::", "/")&.gsub("//", "/")&.gsub("//", "/")
    end
  end
end
