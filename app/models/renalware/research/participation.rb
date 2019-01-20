# frozen_string_literal: true

require_dependency "renalware/research"

module Renalware
  module Research
    class Participation < ApplicationRecord
      include Accountable
      include PatientsRansackHelper

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
    end
  end
end
