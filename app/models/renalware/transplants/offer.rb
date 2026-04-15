# frozen_string_literal: true

module Renalware
  module Transplants
    class Offer < Events::Simple
      include Document::Base

      class Document < Document::Embedded
        attribute :donor_id, String
        attribute :donor_dob, Date

        validates :donor_id, presence: true
        validates :donor_dob,
                  timeliness: {
                    type: :date,
                    on_or_before: -> { Date.current },
                    allow_blank: true
                  }
      end
      has_document

      def partial_for(partial_type)
        File.join("renalware/transplants/offers", partial_type)
      end
    end
  end
end
