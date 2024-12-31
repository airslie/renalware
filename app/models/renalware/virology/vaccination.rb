module Renalware
  module Virology
    class Vaccination < Events::Event
      include Document::Base

      # Return e.g. "renalware/virology/vaccinations/toggled_cell
      def partial_for(partial_type)
        File.join("renalware/virology/vaccinations", partial_type)
      end

      class Document < Document::Embedded
        attribute :type # This used to be a ::Document::Enum but now we load options from the db
        attribute :drug, String
        validates :type, presence: true

        def to_s
          [type_name, drug].compact_blank.join(" - ")
        end

        # Try and find the proper name for the vaccination type - we only store the vaccination
        # type code in the jsonb document. If no match found just display the code eg 'hbv_booster'.
        # The Type might have been deleted (has a deleted_at date) but we still want to display the
        # actual name despite this, we include deleted rows when searching.
        def type_name
          @type_name ||= VaccinationType.with_deleted.find_by(code: type)&.name || type
        end
      end
      has_document
    end
  end
end
