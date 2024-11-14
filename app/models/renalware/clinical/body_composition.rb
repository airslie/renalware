# frozen_string_literal: true

module Renalware
  module Clinical
    class BodyComposition < ApplicationRecord
      include PatientScope
      include Accountable

      # This maps to a PG enum
      enum :pre_post_hd, {
        pre: "pre",
        post: "post"
      }

      belongs_to :patient, class_name: "Renalware::Clinical::Patient", touch: true
      belongs_to :assessor, class_name: "User"
      belongs_to :modality_description, class_name: "Modalities::Description"

      has_paper_trail(
        versions: { class_name: "Renalware::Clinical::Version" },
        on: [:create, :update, :destroy]
      )

      scope :ordered, -> { order(assessed_on: :desc, created_at: :desc) }

      validates :patient, presence: true
      validates :assessor, presence: true
      validates :overhydration, presence: true, numeric_inclusion: { in: -20..20 }
      validates :volume_of_distribution, presence: true, numeric_inclusion: { in: 5..150 }
      validates :total_body_water, presence: true, numeric_inclusion: { in: 0..150 }
      validates :extracellular_water, presence: true, numeric_inclusion: { in: 0..150 }
      validates :intracellular_water, presence: true, numeric_inclusion: { in: 0..150 }
      validates :lean_tissue_index, presence: true, numeric_inclusion: { in: 0..150 }
      validates :fat_tissue_index, presence: true, numeric_inclusion: { in: 0..150 }
      validates :lean_tissue_mass, presence: true, numeric_inclusion: { in: 0..150 }
      validates :fat_tissue_mass, presence: true, numeric_inclusion: { in: 0..150 }
      validates :adipose_tissue_mass, presence: true, numeric_inclusion: { in: 0..100 }
      validates :body_cell_mass, presence: true, numeric_inclusion: { in: 0..150 }
      validates :quality_of_reading, presence: true, numeric_inclusion: { in: 50..100 }
      validates :assessed_on, presence: true, timeliness: { type: :date, allow_blank: false }
      validates :weight, "renalware/patients/weight" => true
    end
  end
end
