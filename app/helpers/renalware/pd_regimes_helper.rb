module Renalware
  module PDRegimesHelper

    def delivery_interval_options
      PD::Regime::VALID_RANGES.delivery_intervals.map do |interval|
        [pluralize(interval, "week"), interval]
      end
    end

    def system_options_for(regime)
      PD::System.for_pd_type(regime.pd_type) { |system| [system.name, system.id] }
    end

    def therapy_times
      PD::APDRegime::VALID_RANGES.therapy_times.map do |minutes|
        [Duration.from_minutes(minutes).to_s, minutes]
      end
    end

    def bag_types
      Renalware::PD::BagType.all.map { |bt| [bt.full_description, bt.id] }
    end

    def default_daily_glucose_average(glucose)
      if glucose.blank?
        0
      else
        glucose
      end
    end

    def capd_apd_scope(regime)
      if regime.capd?
        ["CAPD 3 exchanges per day", "CAPD 4 exchanges per day", "CAPD 5 exchanges per day"]
      else
        ["APD Dry Day", "APD Wet Day", "APD Wet day with additional exchange"]
      end
    end

    def capd_apd_title(regime)
      regime.pd_type.to_s.upcase
    end

    def pd_regime_bag_days(bag)
      days = []
      Date::DAYNAMES.each_with_index do |day, index|
        days << Date::ABBR_DAYNAMES[index] if bag.public_send(day.downcase.to_sym)
      end
      days.join(", ")
    end
  end
end
