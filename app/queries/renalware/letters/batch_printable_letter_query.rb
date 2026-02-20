module Renalware
  module Letters
    class BatchPrintableLetterQuery < LetterQuery
      def initialize(q: nil)
        @q = q || {}
        @q[:gp_send_status_in] = Letter.printable_gp_send_statues
        super
      end
    end
  end
end
