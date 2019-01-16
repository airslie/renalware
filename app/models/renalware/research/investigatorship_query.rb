# frozen_string_literal: true

require_dependency "renalware/research"
require "attr_extras"

module Renalware
  module Research
    class InvestigatorshipQuery
      pattr_initialize [:study!, :options!]

      def call
        search.result
      end

      def search
        study
          .investigatorships
          .ordered
          .eager_load(:user, :hospital_centre)
          .ransack(options)
      end
    end
  end
end
