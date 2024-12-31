module Renalware
  module Modalities
    describe DescriptionPolicy, type: :policy do
      include PolicySpecHelper
      subject { described_class }

      let(:clinician)   { user_double_with_role(:clinical) }
      let(:admin)       { user_double_with_role(:admin) }
      let(:super_admin) { user_double_with_role(:super_admin) }
      let(:description) { instance_double(Description, type: nil) }

      %i(show? index?).each do |permission|
        permissions permission do
          it do
            is_expected.not_to permit(clinician, description)
            is_expected.to permit(admin, description)
            is_expected.to permit(super_admin, description)
          end
        end
      end

      %i(new? create?).each do |permission|
        permissions permission do
          it do
            is_expected.not_to permit(clinician, description)
            is_expected.not_to permit(admin, description)
            is_expected.to permit(super_admin, description)
          end
        end
      end

      context "when the Description has no STI type" do
        let(:description) { instance_double(Description, type: nil) }

        %i(edit? update?).each do |permission|
          permissions permission do
            it do
              is_expected.not_to permit(clinician, description)
              is_expected.not_to permit(admin, description)
              is_expected.to permit(super_admin, description)
            end
          end
        end
      end

      context "when the Description an STI type" do
        let(:description) { instance_double(Description, type: "MyType") }

        %i(edit? update?).each do |permission|
          permissions permission do
            it do
              is_expected.not_to permit(clinician, description)
              is_expected.not_to permit(admin, description)
              is_expected.not_to permit(super_admin, description)
            end
          end
        end
      end

      permissions :destroy? do
        it do
          is_expected.not_to permit(clinician, description)
          is_expected.not_to permit(admin, description)
          is_expected.not_to permit(super_admin, description)
        end
      end
    end
  end
end
