module Renalware
  module Transplants
    class Registration < ApplicationRecord
      include Document::Base
      include PatientScope
      include RansackAll

      belongs_to :patient, touch: true
      has_many :statuses,
               class_name: "RegistrationStatus",
               dependent: :restrict_with_exception
      has_one :current_status,
              -> { where(terminated_on: nil).order([:started_on, :created_at]) },
              class_name: "RegistrationStatus",
              foreign_key: "registration_id",
              dependent: :restrict_with_exception

      has_paper_trail(
        versions: { class_name: "Renalware::Transplants::Version" },
        on: [:create, :update, :destroy]
      )

      has_document class_name: "Renalware::Transplants::RegistrationDocument"

      accepts_nested_attributes_for :statuses

      def add_status!(params)
        Registration.transaction do
          statuses.create(params).tap do |status|
            recompute_termination_dates! if status.valid?
          end
        end
      end

      def update_status!(status, params)
        Registration.transaction do
          if status.update(params)
            recompute_termination_dates!
          end
          status
        end
      end

      def delete_status!(status)
        Registration.transaction do
          status.destroy
          recompute_termination_dates!
        end
      end

      private

      # Set the most recent status terminated_on to nil (so it is active)
      # and then walk back across all other statuses and set the terminated_on
      # to be started_on of the next status. Allow for > 1 status created on the same day.
      def recompute_termination_dates!
        previous_started_on = nil
        statuses.reversed.each do |status|
          status.update_column(:terminated_on, previous_started_on)
          previous_started_on = status.started_on
        end
      end
    end
  end
end
