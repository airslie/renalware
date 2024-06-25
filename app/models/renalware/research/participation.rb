# frozen_string_literal: true

module Renalware
  module Research
    class Participation < ApplicationRecord
      include Accountable
      include PatientsRansackHelper
      include Document::Base
      include RansackAll

      acts_as_paranoid
      has_paper_trail(
        versions: { class_name: "Renalware::Research::Version" },
        on: [:create, :update, :destroy]
      )

      before_validation { self.external_reference = external_reference&.strip }

      validates :patient_id, presence: true, uniqueness: { scope: :study_id }
      validates :study, presence: true
      validates :external_id, uniqueness: true # added by a trigger
      validates :external_reference, uniqueness: { scope: :study_id, allow_blank: true }
      belongs_to :study, touch: true
      belongs_to :patient,
                 class_name: "Renalware::Patient",
                 touch: true

      # Generating a unique id is handled by a Postgres trigger
      # after_save do |participation|
      #   participation.update_column(:external_id, Digest::MD5.hexdigest(id.to_s))
      # end

      # Define this explicitly so that an subclasses will inherit it - otherwise Pundit will try
      # and resolve eg DummyStudy::ParticipationPolicy which won't exist and not need to the
      # implementer to create.
      def self.policy_class = ParticipationPolicy

      def to_s
        patient&.to_s
      end

      def external_application_participation_url
        return if study.application_url.blank?

        study.application_url.gsub("{external_id}", external_id.to_s)
      end

      class Document < Document::Embedded
      end
      has_document
    end
  end
end
