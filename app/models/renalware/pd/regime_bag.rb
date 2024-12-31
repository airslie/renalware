module Renalware
  module PD
    class RegimeBag < ApplicationRecord
      extend Enumerize

      enumerize :role,
                in: [:ordinary, :last_fill, :additional_manual_exchange],
                default: :ordinary,
                scope: :having_role,
                predicates: true

      before_save :assign_days_per_week

      belongs_to :bag_type
      belongs_to :regime, touch: true

      validates :bag_type, presence: true
      validates :volume, presence: true

      validates :volume, numericality: {
        allow_nil: true,
        greater_than_or_equal_to: 100,
        less_than_or_equal_to: 10000
      }

      validate :must_select_one_day

      def initialize(attributes = nil, _options = {})
        super() # !! Rails5 upgrade was super
        Date::DAYNAME_SYMBOLS.each do |day|
          public_send(:"#{day}=", true)
        end
        self.attributes = attributes unless attributes.nil?
      end

      class << self
        RegimeBag.role.each_value do |role|
          define_method role.to_sym do
            having_role(role.to_s)
          end
        end
      end

      def days
        Date::DAYNAME_SYMBOLS.map do |day|
          public_send(day)
        end
      end

      def weekly_total_glucose_ml_per_bag
        days_per_week * volume
      end

      def days_per_week
        days.count(true)
      end

      def has_volume?
        volume.to_i.nonzero?
      end

      private

      def assign_days_per_week
        self.per_week = days_per_week
      end

      def must_select_one_day
        return unless days_per_week == 0

        errors.add(:days, "must be assigned at least one day of the week")
      end
    end
  end
end
