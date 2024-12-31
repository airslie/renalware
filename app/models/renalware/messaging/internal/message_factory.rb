module Renalware
  module Messaging
    module Internal
      class MessageFactory
        def self.build(**attributes)
          attributes[:sent_at] ||= Time.zone.now
          recipient_ids = attributes.delete(:recipient_ids) || []

          Message.new(attributes).tap do |message|
            recipient_ids.each do |recipient_id|
              message.receipts.build(recipient_id: recipient_id)
            end
          end
        end
      end
    end
  end
end
