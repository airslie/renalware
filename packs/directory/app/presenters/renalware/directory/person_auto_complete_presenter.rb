module Renalware
  module Directory
    class PersonAutoCompletePresenter < DumbDelegator
      def name_and_address
        [family_name, given_name, address].compact.join(", ")
      end

      def to_hash
        { id: id, text: name_and_address }
      end
    end
  end
end
