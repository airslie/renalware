# frozen_string_literal: true

module Renalware
  module Letters::Formats::FHIR
    module Support
      module Construction
        extend ActiveSupport::Concern
        include Support::Helpers

        included do
          delegate :letter, to: :arguments
          attr_reader :arguments, :options
        end

        def initialize(arguments, options = {})
          @arguments = arguments
          @options = options
        end

        class_methods do
          def call(arguments, options = {})
            new(arguments, **options).call
          end
        end
      end
    end
  end
end
