# frozen_string_literal: true

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

          group_snapshot_by_code_and_date(snapshot)
        end
      end

      private

      # Note that observation#letter_group determines the group each code falls into,
      # and #letter_order the order codes are displayed within that group., h.g. HGB WBC and PLT
      # are grouped together because they share letter group (1) and within that group the order
      # is determined by letter_order (HGB=1 WBC=2 PLT=3).
      # Results (OBX results) within a groups normally share an observed_at date - ie there is a
      # 1 to 1 relationship between a group and d date output on the letter; most of the time
      # they will arrive in the HL7 feed as part of the same OBR and therefore have the same date.
      # However if, within a group, a code has come in separately with another date, we trigger
      # a new sub group so it gets its own date.
      def group_snapshot_by_code_and_date(snapshot)
        return if snapshot.blank?

        groups = []
        PathologyLayout.new.each_group do |_group_number, obs_desc_group|
          groups << build_hash_of_snapshot_results_keyed_by_date(obs_desc_group, snapshot)
        end
        groups
      end

      def build_hash_of_snapshot_results_keyed_by_date(obs_desc_group, snapshot)
        obs_desc_group.each_with_object({}) do |obs_desc, dates|
          match = snapshot[obs_desc.code.to_sym]
          next if match.nil?
          next if match[:observed_at].nil?

          date = I18n.l(Date.parse(match[:observed_at]))
          dates[date] ||= {}
          dates[date][obs_desc.code] = match[:result]
        end
      end

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
