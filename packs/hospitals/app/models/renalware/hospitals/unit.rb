# frozen_string_literal: true

module Renalware
  module Hospitals
    class Unit < ApplicationRecord
      extend Enumerize

      UNIT_TYPE_RR8_MAP = {
        hospital: "INCENTRE",
        satellite: "INCENTRE",
        home: "HOME",
        assisted: "ASSISTED"
      }.freeze

      belongs_to :hospital_centre,
                 class_name: "Hospitals::Centre",
                 touch: true,
                 counter_cache: true
      has_many :wards,
               class_name: "Hospitals::Ward",
               foreign_key: :hospital_unit_id,
               dependent: :destroy,
               inverse_of: :hospital_unit

      validates :hospital_centre, presence: true
      validates :unit_code, presence: true
      validates :name, presence: true
      validates :renal_registry_code, presence: true
      validates :unit_type, presence: true

      enumerize :unit_type, in: %i(hospital hospital_ward satellite home)

      scope :ordered, -> { order(:name) }
      scope :hd_sites, -> { where(is_hd_site: true) }

      def self.policy_class = BasePolicy

      def to_s
        "#{name} (#{unit_code})"
      end

      # Map unit_type to its equivalent Renal Registry RR8 code.
      def unit_type_rr8
        UNIT_TYPE_RR8_MAP[unit_type.to_sym]
      end
    end
  end
end
