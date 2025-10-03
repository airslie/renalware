# frozen_string_literal: true

module Renalware
  class RemoteMonitoring::RegistrationDetail < Detail
    def view_template
      super do
        DetailItem(document, :referral_reason)
        DetailItem(document, :frequency)
        DetailItem(document, :baseline_creatinine)
      end
    end
  end
end
