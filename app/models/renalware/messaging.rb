module Renalware
  module Messaging
    module_function

    def table_name_prefix = "messaging_"
    def cast_patient(patient) = patient.becomes(Messaging::Patient)
    def cast_author(author) = author.becomes(Messaging::Author)

    module Internal
      module_function

      def cast_author(author) = author.becomes(Messaging::Internal::Author)
      def cast_recipient(recipient) = recipient.becomes(Messaging::Internal::Recipient)
    end
  end
end
