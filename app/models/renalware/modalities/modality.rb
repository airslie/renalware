module Renalware
  module Modalities
    class Modality < ApplicationRecord
      include Accountable
      include PatientScope
      include RansackAll

      belongs_to :description
      belongs_to :patient, touch: true
      belongs_to :reason
      belongs_to :change_type
      belongs_to :source_hospital_centre, class_name: "Hospitals::Centre"
      belongs_to :destination_hospital_centre, class_name: "Hospitals::Centre"

      scope :ordered, -> { order(ended_on: :desc, updated_at: :desc) }
      scope :started_on_reversed, -> { order(started_on: :desc, updated_at: :desc) }
      scope :last_started_on, -> { started_on_reversed.where(ended_on: nil) }

      validates :patient, presence: true
      validates :started_on, presence: true
      validates :description_id, presence: true
      validates :change_type_id, presence: true
      validates :started_on, timeliness: { type: :date, on_or_before: -> { Date.current } }
      validate :validate_modality_starts_later_than_previous, on: :create, if: :patient

      validates(
        :source_hospital_centre_id,
        presence: { if: ->(x) { x.change_type&.require_source_hospital_centre? } }
      )
      validates(
        :destination_hospital_centre_id,
        presence: { if: ->(x) { x.change_type&.require_destination_hospital_centre? } }
      )

      has_paper_trail(
        versions: { class_name: "Renalware::Modalities::Version" },
        on: [:create, :update, :destroy]
      )

      def terminate_by(user, on:)
        self.ended_on = on
        self.state = "terminated"
        save_by!(user, validate: false) # Don't enforce validations here
      end

      def to_s
        description.name
      end

      def change_type_description
        return nil if change_type.blank?

        if change_type.require_source_hospital_centre? &&
           source_hospital_centre.present?
          "#{change_type.name} from #{source_hospital_centre}"
        elsif change_type.require_destination_hospital_centre? &&
              destination_hospital_centre.present?
          "#{change_type.name} to #{destination_hospital_centre}"
        else
          change_type.name
        end
      end

      def terminated?
        state == "terminated"
      end

      private

      def validate_modality_starts_later_than_previous
        unless started_later_than_previous?
          errors.add(:started_on, "can't be before previous modality's start date.")
        end
      end

      def started_later_than_previous?
        if (previous_modality = patient.modalities.last_started_on.first)
          started_on.present? && started_on >= previous_modality.started_on
        else
          true
        end
      end

      def terminate!(successor)
        self.ended_on = successor.started_on
        self.state = "terminated"
        self.by = successor.by
        save!
      end
    end
  end
end
