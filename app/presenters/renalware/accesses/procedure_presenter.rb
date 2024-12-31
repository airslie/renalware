module Renalware
  module Accesses
    # This an experiment to replace DumbDelegator with delegate_missing_to reduce complexity
    # and excessive inheritance tree insertion.
    # - not sure how successful as requires adding 2 lines plus a :to_param workaround
    class ProcedurePresenter
      pattr_initialize :procedure

      # to_param delegation explicitly required here, presumably because the caller checks if the
      # receiver responds_to :to_param - and in the case of our use of delegate_missing_to,
      # it doesn't, so we need to tell it to.
      delegate :to_param, to: :procedure
      class << self
        delegate_missing_to Procedure
      end
      delegate_missing_to :procedure

      def performed_on
        ::I18n.l(super)
      end

      def first_used_on
        ::I18n.l(super)
      end

      def failed_on
        ::I18n.l(super)
      end

      def side
        super.try(:text)
      end
    end
  end
end
