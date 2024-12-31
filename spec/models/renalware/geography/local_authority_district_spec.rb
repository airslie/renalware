# frozen_string_literal: true

module Renalware
  module Geography
    describe LocalAuthorityDistrict do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :code }
    end
  end
end
