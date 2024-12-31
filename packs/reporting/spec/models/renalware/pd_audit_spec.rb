module Renalware
  describe "PD Audit" do # rubocop:disable RSpec/DescribeClass
    include PatientsSpecHelper
    let(:user) { create(:user) }

    describe "json from reporting_pd_audit view" do
      describe ":data" do
        context "when are no rows" do
          pending "TODO"
        end
      end
    end
  end
end
