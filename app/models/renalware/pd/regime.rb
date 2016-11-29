require_dependency "renalware/pd"

module Renalware
  module PD
    class Regime < ActiveRecord::Base
      VALID_RANGES = OpenStruct.new(
        delivery_intervals: [1, 2, 4, 8]
      )

      before_save :set_glucose_volume_percent_1_36
      before_save :set_glucose_volume_percent_2_27
      before_save :set_glucose_volume_percent_3_86

      belongs_to :patient, class_name: "Renalware::Patient"
      belongs_to :system

      has_many :bags, class_name: "Renalware::PD::RegimeBag"
      has_many :bag_types, through: :bags
      has_one :termination,
               class_name: "RegimeTermination",
               dependent: :delete,
               inverse_of: :regime

      accepts_nested_attributes_for :bags, allow_destroy: true

      validates :delivery_interval,
                allow_nil: true,
                numericality: { only_integer: true },
                inclusion: { in: VALID_RANGES.delivery_intervals }
      validates :patient, presence: true
      validates :start_date, presence: true, timeliness: { type: :date }
      validates :end_date,
                timeliness: { type: :date, on_or_after: ->(regime) { regime.start_date } },
                allow_nil: true
      validates :treatment, presence: true
      validate :min_one_bag

      scope :current, -> { eager_load(:termination).where(terminated_on: nil).first }

      def self.current
        Regime.order("created_at DESC").limit(1).first
      end

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

      private

      def min_one_bag
        bags_marked_for_destruction = bags.select(&:marked_for_destruction?)
        remaining_bags = bags - bags_marked_for_destruction
        errors.add(:regime, "must be assigned at least one bag") if remaining_bags.empty?
      end

      def match_bag_type
        glucose_types = [[], [], []]

        bags.each do |bag|
          weekly_total = bag.weekly_total_glucose_ml_per_bag
          glucose_content = bag.bag_type.glucose_content.to_f
          case glucose_content
          when 13.6 then glucose_types[0] << weekly_total
          when 22.7 then glucose_types[1] << weekly_total
          when 38.6 then glucose_types[2] << weekly_total
          else glucose_types
          end
        end
        glucose_types
      end

      def set_glucose_volume_percent_1_36
        if match_bag_type[0].empty?
          0
        else
          per_week_total = match_bag_type[0].inject{ |sum, v| sum + v }
          glucose_daily_average = per_week_total / 7.to_f
          self.glucose_volume_percent_1_36 = glucose_daily_average.round
        end
      end

      def set_glucose_volume_percent_2_27
        if match_bag_type[1].empty?
          0
        else
          per_week_total = match_bag_type[1].inject{ |sum, v| sum + v }
          glucose_daily_average = per_week_total / 7.to_f
          self.glucose_volume_percent_2_27 = glucose_daily_average.round
        end
      end

      def set_glucose_volume_percent_3_86
        if match_bag_type[2].empty?
          0
        else
          per_week_total = match_bag_type[2].inject{ |sum, v| sum + v }
          glucose_daily_average = per_week_total / 7.to_f
          self.glucose_volume_percent_3_86 = glucose_daily_average.round
        end
      end
    end
  end
end
