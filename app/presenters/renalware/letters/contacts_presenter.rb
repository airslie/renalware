module Renalware
  module Letters
    class ContactsPresenter < CollectionPresenter
      # An array of contacts for use in a simple_form drop down.
      # The data-salutation is added (the final hash argument very kindly merges * onto the <option>
      # so we could add other options here too.
      def array_for_drop_down_with_options
        map do |contact|
          [
            contact.name_and_description,
            contact.id,
            {
              data: {
                salutation: contact.salutation,
                class: ".has_salutation"
              }
            }
          ]
        end
      end
    end
  end
end
