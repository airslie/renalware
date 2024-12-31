# When rendered, the template in `to_partial_path` will be used, and our Part object here will be
# available in the partial as `recent_pathology_results`.
module Renalware
  module Letters
    class Part::RecentPathologyResults < Section
      delegate :each, :any?, :present?, to: :results

      def to_partial_path
        "renalware/letters/parts/recent_pathology_results"
      end

      def results
        return if raw_results.blank?

        @results ||= format_groups_into_string(raw_results)
      end

      def raw_results
        @raw_results ||= begin
          snapshot = letter.pathology_snapshot.dup
          return if snapshot.blank?

          PathologyLayout.snapshot_results_keyed_by_date(snapshot)
        end
      end

      private

      # {"07-Jun-2017"=>{"HGB"=>"10.4", "WBC"=>"3.40", "PLT"=>"435"}
      def format_groups_into_string(groups)
        str = ""
        groups.each do |group|
          group.each do |date, observations|
            str += " <span>#{date}</span>: #{observations_as_string(observations)};"
          end
          str = str.strip
        end
        str.html_safe
      end

      def observations_as_string(observations)
        observations.map do |code, result|
          format_code_and_result_string(code, result)
        end.join(", ")
      end

      def format_code_and_result_string(code, result)
        return "(#{code} #{result})" if code.casecmp?("EGFR")

        "#{code} #{result}"
      end
    end
  end
end
