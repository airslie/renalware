module Renalware
  module PD
    class APDRegime < Regime
      include OrderedScope
      include PatientScope

      BAG_VOLUMES = [2000, 2500, 5000].freeze

      enumerize :assistance_type, in: %i(
        none
        setup
        connect
        disconnect
        connect_and_disconnect
      )

      alias_attribute :cycles, :no_cycles_per_apd

      VALID_RANGES = OpenStruct.new(
        therapy_times: (120..900).step(30).to_a,
        fill_volumes: 0..2_500,
        last_fill_volumes: 500..5_000,
        additional_manual_exchange_volumes: 500..5_000,
        cycles_per_apd: 2..20,
        overnight_volumes: 3_000..25_000,
        dwell_times: 10..240,
        tidal_percentages: (60..100).step(5).to_a
      ).freeze

      def drain_every_three_cycles? = tidal_full_drain_every_three_cycles?
      def tidal? = tidal_indicator?

      validates :fill_volume,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: { in: VALID_RANGES.fill_volumes }

      validates :last_fill_volume,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: { in: VALID_RANGES.last_fill_volumes }

      validates :additional_manual_exchange_volume,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: { in: VALID_RANGES.additional_manual_exchange_volumes }

      validates :tidal_percentage,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: { in: VALID_RANGES.tidal_percentages },
                if: :tidal?

      validates :no_cycles_per_apd,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: VALID_RANGES.cycles_per_apd

      validates :overnight_volume,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: VALID_RANGES.overnight_volumes

      validates :daily_volume,
                allow_nil: true,
                numericality: { only_integer: true }

      validates :therapy_time,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: { in: VALID_RANGES.therapy_times }

      validates :dwell_time,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: { in: VALID_RANGES.dwell_times }

      validate :all_active_days_have_the_same_available_volume

      before_save -> { APD::CalculateVolumes.new(self).call }

      validates :no_cycles_per_apd, presence: true
      validates :fill_volume, presence: true

      with_options if: :has_additional_manual_exchange_bag?, on: %i(create update) do
        validates :additional_manual_exchange_volume, presence: true
      end

      with_options if: :has_last_fill_bag?, on: %i(create update) do
        validates :last_fill_volume, presence: true
      end

      with_options if: :tidal?, on: %i(create update) do
        validates :tidal_percentage, presence: true
      end

      def pd_type
        :apd
      end

      def has_additional_manual_exchange_bag?
        bags.any?(&:additional_manual_exchange?)
      end

      def has_last_fill_bag?
        bags.any?(&:last_fill?)
      end

      private

      def all_active_days_have_the_same_available_volume
        APD::AvailableOvernightVolume.new(regime: self).value
      rescue APD::NonUniqueOvernightVolumeError
        errors.add(:base, "The total volume of 'ordinary' bags should be the same on each day " \
                          "the patient has PD")
      end
    end
  end
end
