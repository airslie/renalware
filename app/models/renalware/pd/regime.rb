module Renalware
  module PD
    class Regime < ApplicationRecord
      include Accountable
      extend Enumerize

      enumerize(
        :exchanges_done_by,
        in: %i(
          by_patient
          predominantly_by_patient
          equally_between_patient_and_others
          predominantly_by_others
          only_by_others
        )
      )
      enumerize(
        :exchanges_done_by_if_other,
        in: %i(spouse daughter_son_in_law others_specify mix_specify)
      )

      belongs_to :patient, class_name: "Renalware::Patient", touch: true
      belongs_to :system

      has_many :bags, class_name: "Renalware::PD::RegimeBag", dependent: :restrict_with_exception
      has_many :bag_types, through: :bags
      has_one :termination,
              class_name: "RegimeTermination",
              inverse_of: :regime,
              dependent: :restrict_with_exception

      accepts_nested_attributes_for :bags, allow_destroy: true

      validates :patient, presence: true
      validates :start_date, presence: true, timeliness: { type: :date }
      validates :end_date,
                timeliness: { type: :date, on_or_after: ->(regime) { regime.start_date } },
                allow_blank: true
      validates :treatment, presence: true
      validate :min_one_bag

      scope :current, -> { eager_load(:termination).where(terminated_on: nil).first }
      scope :with_bags, -> { eager_load(bags: [:bag_type]) }

      def self.current
        Regime.order("pd_regimes.created_at DESC").limit(1).with_bags.first
      end

      def self.policy_class = RegimePolicy

      def current?
        Regime.current == self
      end

      def terminated?
        termination.present?
      end

      def apd?
        pd_type == :apd
      end

      def capd?
        pd_type == :capd
      end

      def pd_type
        raise NotImplementedError
      end

      def has_additional_manual_exchange_bag?
        false
      end

      def deep_dup
        regime = dup
        regime.bags = bags.map(&:dup)
        regime
      end

      def deep_restore_attributes
        restore_attributes
        bags.reload
        with_bag_destruction_marks_removed
      end

      # changed_for_autosave? is an AR method that will recursively check the in-memory
      # regime and its bags for changes or any bags marked for destruction.
      def anything_changed?
        changed_for_autosave?
      end

      def with_bag_destruction_marks_removed
        bags.select(&:marked_for_destruction?).each(&:reload)
        self
      end

      def terminate(by:, terminated_on: Date.current)
        build_termination(by: by, terminated_on: terminated_on)
        self
      end

      attr_accessor :total_potential_fluid_available_for_overnight_exchanges

      private

      def min_one_bag
        bags_marked_for_destruction = bags.select(&:marked_for_destruction?)
        remaining_bags = bags - bags_marked_for_destruction
        errors.add(:regime, "must be assigned at least one bag") if remaining_bags.empty?
      end
    end
  end
end
