module Renalware
  module Medications
    class ProviderCodePresenter
      pattr_initialize :hash
      delegate :to_s, to: :code

      def code = hash[:code]
      def to_label = " #{::I18n.t(to_s, scope: 'enums.provider')}"
    end
  end
end
