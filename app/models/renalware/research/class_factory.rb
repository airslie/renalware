# frozen_string_literal: true

require_dependency "renalware/research"
require "attr_extras"

module Renalware
  module Research
    class ClassFactory
      pattr_initialize [:namespace!]
      DEFAULT_NAMESPACE = "Renalware::Research"

      class UnresolvedResearchNamespaceOrClassError < StandardError; end

      def study
        find_namespaced_class_if_exists_else_use_default("Study")
      end

      def participation
        find_namespaced_class_if_exists_else_use_default("Participation")
      end

      def investigatorship
        find_namespaced_class_if_exists_else_use_default("Investigatorship")
      end

      private

      def find_namespaced_class_if_exists_else_use_default(class_name)
        if namespace.present?
          klass = "#{namespace}::#{class_name}"
          return klass.constantize if Object.const_defined?(klass)

          raise UnresolvedResearchNamespaceOrClassError, "Not defined: #{klass}"
        end

        "Renalware::Research::#{class_name}".constantize
      end
    end
  end
end
