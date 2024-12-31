module Renalware
  module Accesses
    class AssessmentDocument < Document::Embedded
      class Results < Document::Embedded
        attribute :method, Document::Enum
        attribute :flow_feed_artery
        attribute :has_art_stenosis, Document::Enum, enums: %i(yes no)
        attribute :art_stenosis_notes
        attribute :has_ven_stenosis, Document::Enum, enums: %i(yes no)
        attribute :ven_stenosis_notes
        attribute :has_residual_stenosis, Document::Enum, enums: %i(yes no)
        attribute :outcome, Document::Enum
      end
      attribute :results, Results

      class Admin < Document::Embedded
        attribute :next_surveillance, Document::Enum
        attribute :decision
      end
      attribute :admin, Admin
    end
  end
end
