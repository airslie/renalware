module Renalware
  module Modalities
    describe ModalityPolicy, type: :policy do
      include PolicySpecHelper
      subject { described_class }

      let(:clinician)   { user_double_with_role(:clinical) }
      let(:admin)       { user_double_with_role(:admin) }
      let(:super_admin) { user_double_with_role(:super_admin) }
      let(:modality)    { instance_double(Modality) }

      %i(show? index? new? create?).each do |permission|
        permissions permission do
          it do
            is_expected.to permit(clinician, modality)
            is_expected.to permit(admin, modality)
            is_expected.to permit(super_admin, modality)
          end
        end
      end

      %i(edit? update? destroy?).each do |permission|
        permissions permission do
          it do
            is_expected.not_to permit(clinician, modality)
            is_expected.to permit(admin, modality)
            is_expected.to permit(super_admin, modality)
          end
        end
      end

      context "when config.allow_modality_history_amendments is false" do
        before do
          allow(Renalware.config).to receive(:allow_modality_history_amendments).and_return(false)
        end

        %i(show? index? new? create?).each do |permission|
          permissions permission do
            it do
              is_expected.to permit(clinician, modality)
              is_expected.to permit(admin, modality)
              is_expected.to permit(super_admin, modality)
            end
          end
        end

        %i(edit? update? destroy?).each do |permission|
          permissions permission do
            it do
              is_expected.not_to permit(clinician, modality)
              is_expected.not_to permit(admin, modality)
              is_expected.not_to permit(super_admin, modality)
            end
          end
        end
      end
    end
  end
end
