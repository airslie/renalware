# frozen_string_literal: true

module Renalware
  module Transplants
    class Offer < Events::Simple
      include Document::Base

      class Document < Document::Embedded
        attribute :donor_id, String

        validates :donor_id, presence: true
      end
      has_document

      def partial_for(partial_type)
        File.join("renalware/transplants/offers", partial_type)
      end
    end
  end
end
