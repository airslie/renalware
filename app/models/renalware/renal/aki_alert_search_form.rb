module Renalware
  module Renal
    class AKIAlertSearchForm
      include ActiveModel::Model
      include Virtus::Model

      attribute :date, Date
      attribute :hospital_centre_id, Integer
      attribute :hospital_ward_id, Integer
      attribute :action, String
      attribute :term, String
      attribute :on_hotlist, String
      attribute :s, String
      attribute :max_aki, String
      attribute :date_range, String

      DATE_RANGE_TODAY = "created_at_within_configured_today_period".freeze
      DATE_RANGE_ALL = "all".freeze
      DATE_RANGE_SPECIFIC_DATE = "specific_date".freeze

      def date_query
        self.date_range ||= DATE_RANGE_TODAY

        case date_range
        when DATE_RANGE_TODAY then configured_daily_period
        when DATE_RANGE_SPECIFIC_DATE then { created_at_as_date_eq: date }
        else {}
        end
      end

      def date_range_options
        [
          [
            "24 hours up til #{daily_period_start_time}",
            DATE_RANGE_TODAY,
            { "data-hide" => "specific-date" }
          ],
          [
            "All",
            DATE_RANGE_ALL,
            { "data-hide" => "specific-date" }
          ],
          [
            "Specific date",
            DATE_RANGE_SPECIFIC_DATE,
            { "data-show" => "specific-date" }
          ]
        ]
      end

      def show_specific_date_input?
        date_range == DATE_RANGE_SPECIFIC_DATE
      end

      def daily_period_start_time
        Renalware.config.aki_alerts_daily_period_start_time # eg "09:45"
      end

      # At Kings AKI the 'today' list of AKI alerts comprises those received in
      # the 24 hours preceding 0945 this morning.
      def configured_daily_period
        start_time = daily_period_start_time
        period_end = Time.zone.today + Time.zone.parse(start_time).seconds_since_midnight.seconds
        period_start = period_end - 1.day

        {
          created_at_gteq: period_start,
          created_at_lt: period_end
        }
      end

      def query
        @query ||= begin
          options = {
            identity_match: term,
            hospital_ward_id_eq: hospital_ward_id,
            hospital_centre_id_eq: hospital_centre_id,
            action_id_eq: action,
            hotlist_eq: on_hotlist,
            max_aki_eq: max_aki,
            s: s
          }.merge(date_query)
          AKIAlertQuery.new(options)
        end
      end
    end
  end
end
