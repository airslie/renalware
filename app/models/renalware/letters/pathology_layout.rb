module Renalware
  module Letters
    class PathologyLayout
      def self.snapshot_results_keyed_by_date(snapshot)
        groups = []
        new.each_group do |_group_number, obs_desc_group|
          groups << build_hash_of_snapshot_results_keyed_by_date(obs_desc_group, snapshot)
        end
        groups
      end

      def self.build_hash_of_snapshot_results_keyed_by_date(obs_desc_group, snapshot)
        obs_desc_group.each_with_object({}) do |obs_desc, dates|
          match = snapshot[obs_desc.code.to_sym]
          next if match.nil?
          next if match[:observed_at].nil?

          date = I18n.l(Date.parse(match[:observed_at]))
          dates[date] ||= {}
          dates[date][obs_desc.code] = match[:result]
        end
      end

      # This method helps us iterate over the pathology required in a letter.
      # Path in letters should be grouped and ordered within that group.
      # We might display a date only once a group for instance.
      def each_group
        Pathology::ObservationDescription
          .select(:id, :code, :letter_group, :letter_order)
          .where.not(letter_group: nil)
          .order("letter_group asc, letter_order asc")
          .group_by(&:letter_group)
          .each do |group_number, descriptions|
          yield(group_number, descriptions) if block_given?
        end
      end
    end
  end
end
