module Renalware
  module Research
    class StudyEvent < Events::Event
      include Document::Base
      validates :subtype_id, presence: true

      class Document < Document::Embedded
        (1..5).each do |idx|
          attribute :"number#{idx}", Float
          validates :"number#{idx}", numericality: true, allow_blank: true
          attribute :"text#{idx}", String
          attribute :"date#{idx}", Date
        end
      end
      has_document

      def self.subtypes?
        true
      end

      def partial_for(partial_type)
        File.join("renalware/research/study_events", partial_type)
      end
    end
  end
end
