# frozen_string_literal: true

require_dependency "renalware/research"
require "document/base"

module Renalware
  module Research
    class Investigatorship < ApplicationRecord
      include Accountable
      include Document::Base
      acts_as_paranoid
      belongs_to :user
      belongs_to :study
      belongs_to :hospital_centre, class_name: "Renalware::Hospitals::Centre"

      validates :user, presence: true
      validates :study, presence: true
      validates :hospital_centre, presence: true

      validates :user_id, uniqueness: { scope: :study_id }

      delegate :to_s, to: :user

      scope :ordered, -> { order(created_at: :desc) }

      # Define this explicity so that an subclasses will inherit it - otherwise Pundit will try
      # and resolve eg DummyStudy::InvestigatorshipPolicy which won't exist and not need to the
      # impementor to create.
      def self.policy_class
        InvestigatorshipPolicy
      end

      class Document < Document::Embedded
        # attribute :test, String
      end
      has_document class_name: "Document"
    end
  end
end
