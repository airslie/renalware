module Renalware
  module PDRegimesHelper
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
      glucose.presence || 0
    end

    # The list of treatment options, stored in I18n
    def available_pd_treatments_for(regime)
      scope = "renalware.pd.treatments"
      key = regime.capd? ? "capd" : "apd"
      I18n.t(key, scope: scope)
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
