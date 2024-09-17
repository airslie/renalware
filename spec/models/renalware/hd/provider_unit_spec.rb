# frozen_string_literal: true

module Renalware
  module HD
    describe ProviderUnit do
      it :aggregate_failures do
        is_expected.to belong_to(:hospital_unit)
        is_expected.to belong_to(:hd_provider)
        is_expected.to validate_presence_of(:hospital_unit)
        is_expected.to validate_presence_of(:hd_provider)
        is_expected.to have_db_index(%i(hd_provider_id hospital_unit_id)).unique(true)
      end
    end
  end
end
