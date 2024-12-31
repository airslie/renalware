module Renalware
  module Transplants
    class DonorOperation < ApplicationRecord
      include Document::Base
      include PatientScope
      extend Enumerize

      belongs_to :patient, touch: true
      has_one :followup,
              class_name: "DonorFollowup",
              foreign_key: "operation_id",
              dependent: :restrict_with_exception

      scope :ordered, -> { order(performed_on: :asc) }
      scope :reversed, -> { order(performed_on: :desc) }

      has_paper_trail(
        versions: { class_name: "Renalware::Transplants::Version" },
        on: [:create, :update, :destroy]
      )
      has_document class_name: "Renalware::Transplants::DonorOperationDocument"

      enumerize :kidney_side, in: %i(left right both)
      enumerize :operating_surgeon, in: %i(consultant fellow_senior_registrar other)
      enumerize :anaesthetist, in: %i(consultant fellow_senior_registrar other)
      enumerize :nephrectomy_type, in: %i(
        open_transperitoneal open_loin_with_resection open_loin_without_resection
        open_extraperitoneal laparoscropic_intra laparoscropic_extra other
      )
      enumerize :donor_splenectomy_peri_or_post_operatively, in: %i(yes no unknown)

      validates :performed_on, presence: true

      def self.policy_class = BasePolicy
    end
  end
end
