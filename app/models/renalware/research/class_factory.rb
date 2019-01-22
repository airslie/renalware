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
          qualified_class_name = "#{namespace}::#{class_name}".gsub("::::", "::")
          if class_exists?(qualified_class_name)
            return qualified_class_name.constantize
          else
            qualified_class_name.constantize
            raise UnresolvedResearchNamespaceOrClassError, "Not defined: #{qualified_class_name}"
          end
        end

        "Renalware::Research::#{class_name}".constantize
      end

      def class_exists?(qualified_class_name)
        klass = Module.const_get(qualified_class_name) # may raise NameError
        klass.is_a?(Class)
      rescue NameError
        false
      end
    end
  end
end
