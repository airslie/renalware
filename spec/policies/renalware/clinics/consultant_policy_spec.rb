module Renalware
  module Clinics
    describe ConsultantPolicy, type: :policy do
      include PolicySpecHelper
      subject { described_class }

      let(:clinician)   { user_double_with_role(:clinical) }
      let(:admin)       { user_double_with_role(:admin) }
      let(:super_admin) { user_double_with_role(:super_admin) }
      let(:description) { instance_double(Consultant, persisted?: true, deleted?: false) }

      context "when the consultant is not deleted" do
        %i(new? create? edit? update? destroy?).each do |permission|
          permissions permission do
            it do
              is_expected.not_to permit(clinician, description)
              is_expected.not_to permit(admin, description)
              is_expected.to permit(super_admin, description)
            end
          end
        end

        %i(show? index?).each do |permission|
          permissions permission do
            it do
              is_expected.not_to permit(clinician, description)
              is_expected.to permit(admin, description)
              is_expected.to permit(super_admin, description)
            end
          end
        end
      end

      context "when the consultant is deleted" do
        let(:description) { instance_double(Consultant, persisted?: true, deleted?: true) }

        %i(edit? destroy? update?).each do |permission|
          permissions permission do
            it do
              is_expected.not_to permit(clinician, description)
              is_expected.not_to permit(admin, description)
              is_expected.not_to permit(super_admin, description)
            end
          end
        end
      end
    end
  end
end
