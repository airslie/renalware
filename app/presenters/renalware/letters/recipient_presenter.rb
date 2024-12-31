module Renalware
  module Letters
    class RecipientPresenter < DumbDelegator
      # We don't rely on `to_s` in this case as the string will not be marked as
      # HTML safe if we leave it to be implicitly called in the template.
      #
      def to_html
        AddressPresenter::Block.new(address_for_addressee).to_html
      end

      def address
        AddressPresenter.new(address_for_addressee)
      end

      private

      def address_for_addressee
        __getobj__&.address
      end

      # The address for a recipient such as a primary care physician or a patient are
      # denormalized and stored with the recipient when the letter is archived.
      # Before the letter is archived, we display the current address directly
      # from the appropriate models ensuring the most recent address is presented.
      #
      class WithCurrentAddress < RecipientPresenter
        private

        def address_for_addressee
          __getobj__.current_address
        end
      end
    end
  end
end
