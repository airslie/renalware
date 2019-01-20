# frozen_string_literal: true

require_dependency "renalware/research"

module Renalware
  module Research
    class Study < ApplicationRecord
      include Accountable
      acts_as_paranoid

      validates :code, presence: true, uniqueness: { scope: :deleted_at }
      validates :description, presence: true
      validates :started_on, timeliness: { type: :date, allow_blank: true }
      validates :terminated_on, timeliness: { type: :date, allow_blank: true, after: :started_on }

      scope :ordered, -> { order(code: :asc) }

      has_many :participations,
               class_name: "Participation",
               dependent: :destroy,
               inverse_of: :study

      has_many :patients,
               class_name: "Renalware::User",
               through: :participations
    end
  end
end
