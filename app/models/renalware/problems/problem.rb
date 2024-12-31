module Renalware
  module Problems
    class Problem < ApplicationRecord
      include PatientScope
      include Accountable
      acts_as_paranoid
      acts_as_list scope: :patient_id

      # A controller #sort action might for instance invoke this class method on an object.
      # The array of ids are the model to sort, and sorting is done by updating each model's
      # position to reflect their place in the array.
      def self.sort(ids)
        Array(ids).each_with_index do |id, index|
          where(id: id).update_all(["position=?", index + 1])
        end
      end

      has_paper_trail(
        versions: { class_name: "Renalware::Problems::Version" },
        on: %i(create update destroy)
      )

      belongs_to :patient, touch: true
      has_many :notes, -> { ordered }, dependent: :destroy

      scope :position_sorting_scope, ->(problem) { where(patient_id: problem.patient.id) }
      scope :ordered, -> { order(position: :asc, created_at: :asc) }
      scope :with_notes, -> { eager_load(:notes).merge(Renalware::Problems::Note.ordered) }
      scope :with_patient, -> { includes(:patient) }
      scope :with_versions, -> { includes(versions: :item) }

      validates :patient, presence: true
      validates :description, presence: true

      def self.with_archived
        with_deleted
      end

      def self.current
        all.with_notes.with_updated_by.with_created_by.ordered
      end

      def self.archived
        only_deleted.with_notes.with_updated_by.with_created_by.ordered
      end

      def self.reject_if_proc
        proc { |attrs| attrs[:description].blank? }
      end

      def archived? = deleted?
      def archived_at = deleted_at
      def archived_on = deleted_at.to_date
      def created_on = created_at.to_date
      def updated_on = updated_at.to_date
      def full_description = description
      def formatted = "#{full_description}, #{date}"
    end
  end
end
