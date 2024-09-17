# frozen_string_literal: true

module Renalware
  module Research
    class Investigatorship < ApplicationRecord
      include Accountable
      include Document::Base
      acts_as_paranoid
      has_paper_trail(
        versions: { class_name: "Renalware::Research::Version" },
        on: [:create, :update, :destroy]
      )

      belongs_to :user
      belongs_to :study

      validates :user, presence: true
      validates :study, presence: true
      validates :started_on, presence: true

      validates :user_id, uniqueness: { scope: :study_id }

      delegate :to_s, to: :user

      scope :ordered, -> { order(created_at: :desc) }

      # Define this explicitly so that an subclasses will inherit it - otherwise Pundit will try
      # and resolve eg DummyStudy::InvestigatorshipPolicy which won't exist and not need to the
      # implementer to create.
      def self.policy_class = InvestigatorshipPolicy

      class Document < Document::Embedded
        # attribute :test, String
      end
      has_document
    end
  end
end
