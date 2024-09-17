# frozen_string_literal: true

module Renalware
  module Pathology
    describe CodeGroupPolicy, type: :policy do
      include PatientsSpecHelper
      include PolicySpecHelper
      subject { described_class }

      let(:code_group) do
        instance_double(
          Renalware::Pathology::CodeGroup
        )
      end

      let(:clinician) { user_double_with_role(:clinical) }
      let(:admin) { user_double_with_role(:admin) }
      let(:super_admin) { user_double_with_role(:super_admin) }

      permissions :index? do
        it "applies correctly.", :aggregate_failures do
          is_expected.to permit(clinician, code_group)
          is_expected.to permit(admin, code_group)
          is_expected.to permit(super_admin, code_group)
        end
      end

      %i(create? edit? update? destroy?).each do |permission|
        permissions permission do
          it "applies correctly", :aggregate_failures do
            is_expected.not_to permit(clinician, code_group)
            is_expected.not_to permit(admin, code_group)
            is_expected.to permit(super_admin, code_group)
          end
        end
      end
    end
  end
end
