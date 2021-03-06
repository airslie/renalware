# frozen_string_literal: true

require_dependency "renalware/renal"

module Renalware
  module Renal
    class AKIAlert < ApplicationRecord
      include Accountable
      include PatientsRansackHelper
      scope :ordered, -> { order(created_at: :desc) }
      belongs_to :patient, class_name: "Renal::Patient", touch: true
      belongs_to :action, class_name: "Renal::AKIAlertAction"
      belongs_to :hospital_ward, class_name: "Hospitals::Ward"
      validates :patient, presence: true
      validates :max_aki, inclusion: 1..3, allow_nil: true
      alias_attribute :decided_by, :updated_by

      scope :today, -> { where(created_at: Time.zone.today.all_day) }
      scope :hotlist, -> { where(hotlist: true) }

      has_paper_trail(
        versions: { class_name: "Renalware::Renal::Version" },
        on: [:create, :update, :destroy]
      )

      ransacker :created_at_casted do |_parent|
        Arel.sql("date(renal_aki_alerts.created_at)")
      end
    end
  end
end
