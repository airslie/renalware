module Renalware
  module Medications
    class ProviderCodePresenter
      pattr_initialize :code
      delegate_missing_to :code
      delegate :to_s, to: :code

      def to_label
        " #{::I18n.t(to_s, scope: 'enums.provider')}"
      end
    end
  end
end
