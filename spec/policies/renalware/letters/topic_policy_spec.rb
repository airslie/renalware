module Renalware
  module Letters
    describe TopicPolicy, type: :policy do
      include PolicySpecHelper
      subject { described_class }

      let(:clinician)     { user_double_with_role(:clinical) }
      let(:admin)         { user_double_with_role(:admin) }
      let(:super_admin)   { user_double_with_role(:super_admin) }
      let(:topic) { instance_double(Topic, deleted?: false) }

      %i(show? index?).each do |permission|
        permissions permission do
          it do
            is_expected.not_to permit(clinician, topic)
            is_expected.to permit(admin, topic)
            is_expected.to permit(super_admin, topic)
          end
        end
      end

      context "when the topic is not deleted" do
        %i(new? create? edit? update? destroy?).each do |permission|
          permissions permission do
            it do
              is_expected.not_to permit(clinician, topic)
              is_expected.not_to permit(admin, topic)
              is_expected.to permit(super_admin, topic)
            end
          end
        end
      end

      context "when the topic is deleted" do
        let(:topic) { instance_double(Topic, deleted?: true) }

        %i(edit? destroy?).each do |permission|
          permissions permission do
            it do
              is_expected.not_to permit(clinician, topic)
              is_expected.not_to permit(admin, topic)
              is_expected.not_to permit(super_admin, topic)
            end
          end
        end
      end
    end
  end
end
