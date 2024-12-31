module Renalware
  module PD
    class TrainingSession < ApplicationRecord
      include Accountable
      include PatientScope
      include OrderedScope
      include Document::Base
      extend Enumerize

      belongs_to :patient, class_name: "Renalware::PD::Patient", touch: true
      belongs_to :training_site, class_name: "Renalware::PD::TrainingSite"
      belongs_to :training_type, class_name: "Renalware::PD::TrainingType"

      attr_reader :ignore_me # see html form for explanation of this non-persistent attribute

      validates :training_site_id, presence: true
      validates :training_type_id, presence: true

      class Document < Document::Embedded
        attribute :started_on, Date
        attribute :trainer, String
        attribute :training_duration, String
        attribute :outcome, ::Document::Enum, enums: %i(successful limited_success unsuccessful)
        attribute :training_comments

        validates :started_on, presence: true
      end
      has_document
    end
  end
end
