module Renalware
  module Messaging
    module Internal
      class SendMessageToUsersWithRole
        include Callable

        pattr_initialize [:author!, :patient!, :role_name!, :subject!, :body!]

        def call # rubocop:disable Metrics/MethodLength
          Message.transaction do
            message = Message.new(
              patient: Messaging.cast_patient(patient),
              author: Internal.cast_author(author),
              subject: subject,
              body: body,
              sent_at: Time.zone.now
            ).tap do |message|
              recipient_ids.each do |recipient_id|
                message.receipts.build(recipient_id: recipient_id)
              end
            end
            message.save!
            message
          end
        end

        private

        def recipient_ids = role.users.pluck(:id)
        def role          = Role.find_by(name: role_name)
      end
    end
  end
end
