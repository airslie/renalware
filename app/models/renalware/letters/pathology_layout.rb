# frozen_string_literal: true

module Renalware
  module Letters
    class PathologyLayout
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
