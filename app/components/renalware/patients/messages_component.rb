# frozen_string_literal: true

module Renalware
  module Patients
    class MessagesComponent < ApplicationComponent
      include ToggleHelper
      include Pagy::Backend
      include Pagy::Frontend

      rattr_initialize [:patient!, :current_user!]

      def pagination
        load_messages unless @pagination
        @pagination
      end

      def messages
        load_messages unless @messages
        @messages
      end

      def formatted_title(title)
        if pagination.limit < pagination.count
          "#{title} (#{pagination.limit} of #{pagination.count})"
        else
          "#{title} (#{pagination.count})"
        end
      end

      private

      def load_messages
        @pagination, @messages = pagy(scope, items: 5, anchor_string: "data-remote='true'")
      end

      def messaging_patient
        @messaging_patient ||= Messaging.cast_patient(patient)
      end

      def scope
        messaging_patient.messages.where(public: true).order(created_at: :desc)
      end
    end
  end
end
