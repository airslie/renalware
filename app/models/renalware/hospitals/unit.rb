require_dependency "renalware/hospitals"

module Renalware
  module Hospitals
    class Unit < ApplicationRecord
      extend Enumerize

      belongs_to :hospital_centre, class_name: "Hospitals::Centre"

      validates :hospital_centre, presence: true
      validates :unit_code, presence: true
      validates :name, presence: true
      validates :renal_registry_code, presence: true
      validates :unit_type, presence: true
      validates :number_of_hd_stations, numericality: { allow_blank: true, only_integer: true }

      enumerize :unit_type, in: %i(hospital satellite home)

      scope :ordered, -> { order(:name) }
      scope :hd_sites, -> { where(is_hd_site: true) }

      def self.policy_class
        BasePolicy
      end

      def to_s
        "#{name} (#{unit_code})"
      end
    end
  end
end
