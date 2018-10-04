# frozen_string_literal: true

require_dependency "renalware/transplants"
require "document/base"

module Renalware
  module Transplants
    class RecipientFollowup < ApplicationRecord
      include Document::Base
      extend Enumerize

      belongs_to :operation,
                 class_name: "RecipientOperation",
                 foreign_key: "operation_id",
                 touch: true
      belongs_to :transplant_failure_cause_description,
                 class_name: "Transplants::FailureCauseDescription",
                 foreign_key: "transplant_failure_cause_description_id"

      has_paper_trail class_name: "Renalware::Transplants::Version",
                      on: [:create, :update, :destroy]
      has_document class_name: "Renalware::Transplants::RecipientFollowupDocument"

      validates :stent_removed_on, timeliness: { type: :date, allow_blank: true }
      validates :transplant_failed_on, timeliness: { type: :date, allow_blank: true }
      validates :transplant_failed_on,
                presence: true,
                if: ->(o) { o.transplant_failed }
      validates :transplant_failure_cause_description_id,
                presence: true,
                if: ->(o) { o.transplant_failed }
      validates :transplant_failure_cause_other,
                presence: true,
                if: ->(o) { o.transplant_failure_cause_description.try(:name) == "Other" }
    end
  end
end
