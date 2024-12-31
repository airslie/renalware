module Renalware
  module HD
    module Scheduling
      NullSlot = Naught.build do |config|
        config.black_hole
        config.define_explicit_conversions
        config.predicates_return false

        attr_reader :diary_id, :diurnal_period_code_id, :station_id, :day_of_week

        def initialize(diary_id, diurnal_period_code_id, station_id, day_of_week)
          @diary_id = diary_id
          @diurnal_period_code_id = diurnal_period_code_id
          @station_id = station_id
          @day_of_week = day_of_week
        end

        def master?
          false
        end

        def cell_id
          "#{diurnal_period_code_id}-#{station_id}-#{day_of_week}"
        end

        def cache_key
          [
            self.class.name,
            diary_id,
            diurnal_period_code_id,
            station_id,
            day_of_week
          ].join("-")
        end
      end
    end
  end
end
