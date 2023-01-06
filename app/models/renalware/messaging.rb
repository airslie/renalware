# frozen_string_literal: true

module Renalware
  module Messaging
    module_function

    def table_name_prefix = "messaging_"

    def cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::Messaging::Patient)
    end

    def cast_author(author)
      ActiveType.cast(author, ::Renalware::Messaging::Author)
    end

    module Internal
      module_function

      def cast_patient(patient)
        ActiveType.cast(patient, ::Renalware::Messaging::Internal::Patient)
      end

      def cast_author(author)
        ActiveType.cast(author, ::Renalware::Messaging::Internal::Author)
      end

      def cast_recipient(recipient)
        ActiveType.cast(recipient, ::Renalware::Messaging::Internal::Recipient)
      end
    end
  end
end
