# frozen_string_literal: true

module Renalware
  module Clinical
    class DukeActivityStatusIndex < Events::Event
      include Document::Base

      class Document < Document::Embedded
        attribute :score, Float
        validates :score,
                  presence: true,
                  numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 60 }
      end
      has_document

      def partial_for(partial_type)
        File.join("renalware/clinical/duke_activity_status_index", partial_type)
      end
    end
  end
end
