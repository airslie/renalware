# frozen_string_literal: true

module Renalware
  module Problems
    class Problem < ApplicationRecord
      include PatientScope
      include Accountable
      include Sortable

      acts_as_paranoid

      has_paper_trail(
        versions: { class_name: "Renalware::Problems::Version" },
        on: [:create, :update, :destroy]
      )

      belongs_to :patient, touch: true
      has_many :notes, -> { ordered }, dependent: :destroy

      scope :ordered, -> { order(position: :asc) }
      scope :with_notes, -> { eager_load(:notes).merge(Renalware::Problems::Note.ordered) }
      scope :with_patient, -> { includes(:patient) }
      scope :with_versions, -> { includes(versions: :item) }

      # This scope is called by Sortable concern
      scope :position_sorting_scope, ->(problem) { where(patient_id: problem.patient.id) }

      validates :patient, presence: true
      validates :description, presence: true

      enum problem_date_display_style_enum: {
        y: "y",
        my: "my",
        dmy: "dmy"
      }

      def self.with_archived
        with_deleted
      end

      def self.current
        all.with_notes.with_updated_by.with_created_by.ordered
      end

      def self.archived
        only_deleted.with_notes.with_updated_by.with_created_by.ordered
      end

      def archived?
        deleted?
      end

      def archived_at
        deleted_at
      end

      def archived_on
        deleted_at.to_date
      end

      def created_on
        created_at.to_date
      end

      def updated_on
        updated_at.to_date
      end

      def self.reject_if_proc
        proc { |attrs| attrs[:description].blank? }
      end

      def full_description
        description
      end

      def formatted
        "#{full_description}, #{date}"
      end
    end
  end
end
