module Renalware
  module Transplants
    class DonorWorkup < ApplicationRecord
      include Document::Base
      include PatientScope

      belongs_to :patient, touch: true

      has_paper_trail(
        versions: { class_name: "Renalware::Transplants::Version" },
        on: [:create, :update, :destroy]
      )
      has_document class_name: "Renalware::Transplants::DonorWorkupDocument"

      def self.policy_class = BasePolicy
    end
  end
end
