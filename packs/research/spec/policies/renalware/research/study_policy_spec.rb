module Renalware
  module Research
    describe StudyPolicy, type: :policy do
      include PolicySpecHelper

      subject(:policy) { described_class }

      let(:clinician) { user_double_with_role(:clinical) }
      let(:admin) { user_double_with_role(:admin) }
      let(:super_admin) { user_double_with_role(:super_admin) }
      let(:investigatorships) { instance_double(ActiveRecord::Relation, pluck: [], where: manager_scope) }
      let(:manager_scope) { instance_double(ActiveRecord::Relation, pluck: []) }
      let(:study) { instance_double(Study, investigatorships: investigatorships) }

      %i(create? edit? new? destroy?).each do |permission|
        permissions permission do
          it do
            is_expected.not_to permit(clinician, study)
            is_expected.to permit(admin, study)
            is_expected.to permit(super_admin, study)
          end
        end
      end
    end
  end
end
