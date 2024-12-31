module Renalware
  module Letters
    class ContactPresenter < DumbDelegator
      def description_name
        description.unspecified? ? other_description : description.to_s
      end

      def name_and_description
        "#{self} (#{description_name})"
      end
    end
  end
end
