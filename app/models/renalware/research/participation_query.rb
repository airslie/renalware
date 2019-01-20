# frozen_string_literal: true

require_dependency "renalware/research"
require "attr_extras"

module Renalware
  module Research
    class ParticipationQuery
      pattr_initialize [:study!, :options!]

      def call
        search.result
      end

      def search
        study.participations.joins(:patient).eager_load(:patient).ransack(options)
      end
    end
  end
end
