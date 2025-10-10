module Renalware
  module Feeds
    module HL7Segments
      # Next of Kin segment. Takes a HL7 NK1 segment decorates it with methods to format it.
      # We don't properly store the NK relationships to the patient. Instead we
      # parse each NK1 segment and write a formatted version of it fo the patients.next_of_kin
      # column.
      class NK1
        attr_initialize :segment
        delegate_missing_to :@segment

        def to_fs
          [
            [formatted_relationship, formatted_name].compact_blank.join("\n"),
            [formatted_phone, formatted_business_phone].compact_blank.join(" / "),
            formatted_address
          ].compact_blank.join("\n")
        end

        private

        def formatted_name
          name_parts = (name || "").split("^")
          [
            name_parts[4], # title
            name_parts[1], # given name
            name_parts[0], # family name
            name_parts[3]  # suffix
          ].compact_blank.join(" ")
        end

        def formatted_relationship = safe_split(:relationship).join(" ")
        def formatted_phone = safe_split(:phone_number)[0]
        def formatted_business_phone = safe_split(:business_phone_number)[0]
        def formatted_address = safe_split(:address).compact_blank.join(", ")
        def safe_split(field) = (send(field) || "").split("^")
      end
    end
  end
end
