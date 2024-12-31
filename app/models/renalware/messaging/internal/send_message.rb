module Renalware
  module Messaging
    module Internal
      class SendMessage
        def self.call(...)
          new.call(...)
        end

        def call(author:, patient:, form:)
          Message.transaction do
            message = MessageFactory.build(patient: patient,
                                           author: author,
                                           **form.attributes)
            message.save!
            message
          end
        end
      end
    end
  end
end
