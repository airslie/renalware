module Renalware
  module Transplants
    describe MDMPatientsQuery do
      it :aggregate_failures do
        is_expected.to respond_to(:call)
        is_expected.to respond_to(:search)
      end
    end
  end
end
