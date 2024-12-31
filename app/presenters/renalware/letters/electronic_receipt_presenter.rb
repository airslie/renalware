module Renalware
  module Letters
    class ElectronicReceiptPresenter < DumbDelegator
      def html_identifier
        "electronic-receipt-#{id}"
      end

      def html_preview_identifier
        "electronic-receipt-preview-#{id}"
      end
    end
  end
end
