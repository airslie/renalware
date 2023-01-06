# frozen_string_literal: true

module Renalware
  module Medications
    module Delivery
      # For example a home delivery form was printed.
      class Event < ApplicationRecord
        include Accountable
        acts_as_paranoid

        belongs_to :patient, class_name: "Renalware::Patient"
        belongs_to :drug_type, class_name: "Drugs::Type"
        belongs_to :homecare_form, class_name: "Drugs::HomecareForm"
        has_many(
          :event_prescriptions,
          class_name: "Delivery::EventPrescription",
          dependent: :restrict_with_exception
        )
        has_many(
          :prescriptions,
          through: :event_prescriptions,
          class_name: "Medications::Prescription",
          dependent: :restrict_with_exception
        )

        validates :patient, presence: true
        validates :homecare_form, presence: true
        validates :reference_number, presence: true, if: :printed?
        validates :prescription_duration, presence: true, if: :printed?
        validate :renalware_forms_args, on: :update

        def self.policy_class
          Renalware::BasePolicy
        end

        def renalware_forms_args
          adapater = Delivery::HomecareFormsAdapter.new(delivery_event: self)
          args = adapater.build_args
          unless adapater.valid?(args)
            errors.add(:base, args.errors.full_messages&.join(", "))
          end
        end
      end
    end
  end
end
