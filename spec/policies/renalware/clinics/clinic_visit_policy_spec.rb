module Renalware
  module Clinics
    describe ClinicVisitPolicy, type: :policy do
      subject(:policy) { described_class }

      let(:user)          { User.new(id: 1) }
      let(:other_user)    { User.new(id: 2) }
      let(:super_admin)   { User.new(id: 99) }
      let(:created_by_id) { nil }
      let(:created_at)    { nil }
      let(:persisted)     { false }
      let(:clinic_visit) do
        instance_double(
          Renalware::Clinics::ClinicVisit,
          created_at: created_at,
          created_by_id: user.id,
          persisted?: persisted
        )
      end

      before do
        Renalware.configure do |config|
          config.new_clinic_visit_deletion_window = 24.hours
          config.new_clinic_visit_edit_window = 7.days
        end
        allow(super_admin).to receive(:has_role?).with(:super_admin).and_return(true)
      end

      permissions :destroy? do
        context "with an unsaved clinic visit" do
          it { is_expected.not_to permit(user, clinic_visit) }
        end

        context "with a saved clinic visit" do
          let(:persisted) { true }

          context "when the creation date is outside the deletion window" do
            let(:created_at) { 25.hours.ago }

            it do
              is_expected.not_to permit(user, clinic_visit)
              is_expected.not_to permit(other_user, clinic_visit)
            end
          end

          context "when the creation date is within the deletion window" do
            let(:created_at) { 23.hours.ago }

            it do
              is_expected.to permit(user, clinic_visit)
              is_expected.to permit(super_admin, clinic_visit)
              is_expected.not_to permit(other_user, clinic_visit)
            end
          end
        end
      end

      permissions :edit? do
        context "with an unsaved clinic visit" do
          it do
            is_expected.not_to permit(user, clinic_visit)
            is_expected.not_to permit(other_user, clinic_visit)
          end
        end

        context "with a saved clinic visit" do
          let(:persisted) { true }

          context "when the visit was created within 7 days" do
            let(:created_at) { 7.days.ago + 1.hour }

            it do
              is_expected.to permit(user, clinic_visit)
              is_expected.not_to permit(other_user, clinic_visit)
            end
          end

          context "when the visit was created more than 7 days ago" do
            let(:created_at) { 7.days.ago - 1.hour }

            it do
              is_expected.not_to permit(user, clinic_visit)
              is_expected.not_to permit(other_user, clinic_visit)
            end
          end
        end
      end
    end
  end
end
