# frozen_string_literal: true

require_dependency "renalware/messaging"

# Builds a new MessageForm form object. MessageForm is used behind the html form when displaying a
# `Send Message` Dialog the first time. Note that we don't use this builder again on e.g.
# form submission - at that point all the required params are in the form payload - this is
# only for the initial MesageForm creation.
#
module Renalware
  module Messaging
    module Internal
      class MessageFormBuilder
        attr_reader :patient, :params

        def initialize(patient:, params:)
          @patient = patient
          @params = params
        end

        def call
          MessageForm.new(
            subject: build_subject,
            recipient_ids: build_recipient_ids,
            replying_to_message_id: replying_to_message_id
          )
        end

        private

        def build_subject
          replying? ? "Re: #{replying_to_message.subject}" : patient.to_s
        end

        def build_recipient_ids
          replying? ? Array(replying_to_message.author_id) : []
        end

        def replying_to_message
          return NullObject.instance unless replying?
          @replying_to_message ||= Message.find(replying_to_message_id)
        end

        def replying_to_message_id
          params[:replying_to_message_id]
        end

        def replying?
          replying_to_message_id.present?
        end
      end
    end
  end
end
