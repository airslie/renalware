# frozen_string_literal: true

require "document/base"

module Renalware
  module Renal
    class Profile < ApplicationRecord
      include Document::Base
      extend Enumerize

      has_paper_trail(
        versions: { class_name: "Renalware::Renal::Version" },
        on: [:create, :update, :destroy]
      )

      belongs_to :patient, touch: true
      belongs_to :prd_description
      has_one :address_at_diagnosis, as: :addressable, class_name: "Address"

      has_document class_name: "Renalware::Renal::ProfileDocument"

      validates :patient, presence: true, uniqueness: true
      validates :esrf_on, timeliness: { type: :date }, allow_blank: true
      validates :first_seen_on,
                timeliness: {
                  type: :date
                },
                allow_blank: true
      validates :comorbidities_updated_on,
                timeliness: {
                  type: :date
                },
                allow_blank: true

      accepts_nested_attributes_for :address_at_diagnosis, reject_if: Address.reject_if_blank

      enumerize :modality_at_esrf, in: %i(HD PD Tx CM)

      def to_s
        [I18n.l(esrf_on), prd_description].compact.join(" ")
      end

      def self.policy_class
        BasePolicy
      end
    end
  end
end
