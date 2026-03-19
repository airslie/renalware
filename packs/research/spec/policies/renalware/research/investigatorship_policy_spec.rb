module Renalware
  module Research
    describe InvestigatorshipPolicy, type: :policy do
      include PolicySpecHelper

      subject(:policy) { described_class }

      let(:super_admin) { build_user(:super_admin, 1) }
      let(:manager) { build_user(:clinical, 2) }
      let(:investigator) { build_user(:clinical, 3) }
      let(:admin) { build_user(:admin, 4) }
      let(:manager_scope) { instance_double(ActiveRecord::Relation, pluck: [manager.id]) }
      let(:investigatorships) do
        instance_double(
          ActiveRecord::Relation,
          pluck: [manager.id, investigator.id],
          where: manager_scope
        )
      end
      let(:study) { instance_double(Study, investigatorships: investigatorships) }
      let(:investigatorship) { instance_double(Investigatorship, study: study) }

      %i(destroy? edit? new? create? update?).each do |permission|
        permissions permission do
          it do
            is_expected.to permit(super_admin, investigatorship)
            is_expected.to permit(manager, investigatorship)
            is_expected.not_to permit(investigator, investigatorship)
            is_expected.not_to permit(admin, investigatorship)
          end
        end
      end

      context "when the investigatorship has no study" do
        let(:investigatorship) { instance_double(Investigatorship, study: nil) }

        %i(destroy? edit? new? create? update?).each do |permission|
          permissions permission do
            it do
              is_expected.not_to permit(super_admin, investigatorship)
              is_expected.not_to permit(manager, investigatorship)
            end
          end
        end
      end

      def build_user(role, id)
        user_double_with_role(role).tap do |user|
          allow(user).to receive(:id).and_return(id)
        end
      end
    end
  end
end
