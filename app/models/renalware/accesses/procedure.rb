# frozen_string_literal: true

require_dependency "renalware/accesses"

module Renalware
  module Accesses
    class Procedure < ApplicationRecord
      include Accountable
      extend Enumerize

      belongs_to :patient, touch: true
      belongs_to :type, class_name: "Type"
      belongs_to :pd_catheter_insertion_technique, class_name: "CatheterInsertionTechnique"

      has_paper_trail class_name: "Renalware::Accesses::Version", on: [:create, :update, :destroy]

      scope :ordered, -> { order(performed_on: :desc) }

      validates :type, presence: true
      validates :performed_by, presence: true
      validates :performed_on, presence: true
      validates :performed_on, timeliness: { type: :date, allow_blank: false }
      validates :first_used_on, timeliness: { type: :date, allow_blank: true }
      validates :failed_on, timeliness: { type: :date, allow_blank: true }

      enumerize :side, in: %i(left right)
    end
  end
end
