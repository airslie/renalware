module Renalware
  module Hospitals
    class Centre < ApplicationRecord
      include RansackAll

      has_many :units,
               class_name: "Hospitals::Unit",
               foreign_key: :hospital_centre_id,
               dependent: :restrict_with_exception

      has_many :departments,
               class_name: "Hospitals::Department",
               foreign_key: :hospital_centre_id,
               dependent: :restrict_with_exception

      scope :ordered, -> { order(:name) }
      scope :ordered_for_dropdowns, -> { order(position: :asc, name: :asc) }
      scope :active, -> { where(active: true) }
      scope :host_site, -> { where(host_site: true) }
      scope :default, -> { where(default_site: true) }

      scope :performing_transplant, -> { active.where(is_transplant_site: true) }

      # rubocop:disable Rails/PluckInWhere
      scope :with_hd_sites, -> { where(id: Unit.hd_sites.pluck(:hospital_centre_id)) }
      # rubocop:enable Rails/PluckInWhere

      validates :code, presence: true, uniqueness: true
      validates :abbrev, uniqueness: true, allow_blank: true
      validates :name, presence: true

      def self.policy_class = BasePolicy

      def hd_sites
        units.hd_sites.ordered
      end

      def to_s
        if location.present?
          "#{name} (#{location})"
        else
          name
        end
      end
    end
  end
end
