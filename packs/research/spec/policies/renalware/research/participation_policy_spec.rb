module Renalware
  module Research
    describe ParticipationPolicy, type: :policy do
      include PolicySpecHelper

      subject(:policy) { described_class }

      let(:super_admin) { build_user(:super_admin, 1) }
      let(:admin) { build_user(:admin, 2) }
      let(:investigator) { build_user(:clinical, 3) }
      let(:manager) { build_user(:clinical, 4) }
      let(:other_user) { build_user(:clinical, 5) }
      let(:manager_scope) { instance_double(ActiveRecord::Relation, pluck: [manager.id]) }
      let(:investigatorships) do
        instance_double(
          ActiveRecord::Relation,
          pluck: [investigator.id, manager.id],
          where: manager_scope
        )
      end
      let(:study) { instance_double(Study, investigatorships: investigatorships) }
      let(:participation) { instance_double(Participation, study: study) }

      before do
        allow(Renalware.config)
          .to receive(:research_anyone_can_manage_participations)
          .and_return(false)
      end

      context "when the participation has a study" do
        %i(create? edit? new?).each do |permission|
          permissions permission do
            it do
              is_expected.to permit(super_admin, participation)
              is_expected.not_to permit(admin, participation)
              is_expected.to permit(investigator, participation)
              is_expected.to permit(manager, participation)
              is_expected.not_to permit(other_user, participation)
            end
          end
        end

        permissions :destroy? do
          it do
            is_expected.to permit(super_admin, participation)
            is_expected.not_to permit(admin, participation)
            is_expected.not_to permit(investigator, participation)
            is_expected.to permit(manager, participation)
            is_expected.not_to permit(other_user, participation)
          end
        end
      end

      context "when anyone can manage participations" do
        before do
          allow(Renalware.config)
            .to receive(:research_anyone_can_manage_participations)
            .and_return(true)
        end

        %i(create? edit? new? destroy?).each do |permission|
          permissions permission do
            it do
              is_expected.to permit(super_admin, participation)
              is_expected.to permit(admin, participation)
              is_expected.to permit(investigator, participation)
              is_expected.to permit(manager, participation)
              is_expected.to permit(other_user, participation)
            end
          end
        end
      end

      context "when the participation has no study" do
        let(:participation) { instance_double(Participation, study: nil) }

        %i(create? edit? new? destroy?).each do |permission|
          permissions permission do
            it do
              is_expected.not_to permit(super_admin, participation)
              is_expected.not_to permit(investigator, participation)
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
