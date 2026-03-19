module Renalware
  module Research
    describe ResearchPolicy, type: :policy do
      include PolicySpecHelper

      subject(:policy) { described_class }

      let(:clinician) { user_double_with_role(:clinical) }
      let(:admin) { user_double_with_role(:admin) }
      let(:super_admin) { user_double_with_role(:super_admin) }
      let(:study) { instance_double(Study, investigatorships: investigatorships) }
      let(:record) { instance_double(Participation, study: study) }
      let(:investigatorships) { instance_double(ActiveRecord::Relation, pluck: [], where: manager_scope) }
      let(:manager_scope) { instance_double(ActiveRecord::Relation, pluck: []) }

      %i(create? edit? new? destroy?).each do |permission|
        permissions permission do
          it do
            is_expected.not_to permit(clinician, record)
            is_expected.to permit(admin, record)
            is_expected.to permit(super_admin, record)
          end
        end
      end
    end
  end
end
