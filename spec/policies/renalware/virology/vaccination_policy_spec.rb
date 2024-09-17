# frozen_string_literal: true

module Renalware
  module Virology
    describe VaccinationPolicy, type: :policy do
      include PolicySpecHelper
      subject(:policy) { described_class }

      let(:admin) { user_double_with_role(:admin) }
      let(:superadmin) { user_double_with_role(:super_admin) }

      %i(edit? update? destroy?).each do |permission|
        permissions permission do
          it "disallows admins" do
            expect(policy).not_to permit(admin, Vaccination.new)
          end

          it "allows superadmins" do
            expect(policy).to permit(superadmin, Vaccination.new)
          end
        end
      end
    end
  end
end
