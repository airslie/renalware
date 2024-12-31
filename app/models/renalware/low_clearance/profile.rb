module Renalware
  module LowClearance
    class Profile < ApplicationRecord
      include Accountable
      include Document::Base
      validates :patient, presence: true
      belongs_to :patient, touch: true
      belongs_to :referrer
      belongs_to :dialysis_plan, optional: true
      has_document class_name: "Renalware::LowClearance::ProfileDocument"

      has_paper_trail(
        versions: { class_name: "Renalware::LowClearance::Version" },
        on: %i(create update destroy)
      )
    end
  end
end
