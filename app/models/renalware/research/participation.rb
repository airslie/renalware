# frozen_string_literal: true

require_dependency "renalware/research"
require "document/base"

module Renalware
  module Research
    class Participation < ApplicationRecord
      include Accountable
      include PatientsRansackHelper
      include Document::Base
      acts_as_paranoid
      validates :patient_id, presence: true, uniqueness: { scope: :study }
      validates :study, presence: true
      validates :external_id, uniqueness: true # added by a trigger
      belongs_to :study, touch: true
      belongs_to :patient,
                 class_name: "Renalware::Patient",
                 touch: true

      # Generating a unique id is handled by a Postgres trigger
      # after_save do |participation|
      #   participation.update_column(:external_id, Digest::MD5.hexdigest(id.to_s))
      # end

      def to_s
        patient&.to_s
      end

      def external_application_participation_url
        return if study.application_url.blank?

        study.application_url.gsub("{external_id}", external_id.to_s)
      end

      # Define this explicity so that an subclasses will inherit it - otherwise Pundit will try
      # and resolve eg DummyStudy::ParticipationPolicy which won't exist and not need to the
      # impementor to create.
      def self.policy_class
        ParticipationPolicy
      end

      class Document < Document::Embedded
      end
      has_document
    end
  end
end
