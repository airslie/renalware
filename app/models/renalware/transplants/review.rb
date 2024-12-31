module Renalware
  module Transplants
    class Review < Events::Event
      belongs_to :patient, class_name: "Renalware::Patient"

      def partial_for(partial_type)
        File.join("renalware/transplants/reviews", partial_type)
      end
    end
  end
end
