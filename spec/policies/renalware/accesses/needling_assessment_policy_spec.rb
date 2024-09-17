# frozen_string_literal: true

module Renalware
  module Accesses
    describe NeedlingAssessmentPolicy, type: :policy do
      include PolicySpecHelper
      subject { described_class }

      let(:clinician)   { user_double_with_role(:clinical) }
      let(:admin)       { user_double_with_role(:admin) }
      let(:super_admin) { user_double_with_role(:super_admin) }
      let(:assessment)  { instance_double(NeedlingAssessment, persisted?: true) }

      %i(new? create?).each do |permission|
        permissions permission do
          it do
            is_expected.to permit(clinician, assessment)
            is_expected.to permit(admin, assessment)
            is_expected.to permit(super_admin, assessment)
          end
        end
      end

      %i(show? index? update? edit?).each do |permission|
        permissions permission do
          it do
            is_expected.not_to permit(clinician, assessment)
            is_expected.not_to permit(admin, assessment)
            is_expected.not_to permit(super_admin, assessment)
          end
        end
      end

      %i(destroy?).each do |permission|
        permissions permission do
          context "when the deletion window has not expired" do
            before do
              Renalware.configure do |config|
                config.new_clinic_visit_deletion_window = 24.hours
              end
            end

            let(:assessment) do
              instance_double(NeedlingAssessment, persisted?: true, created_at: Time.zone.now)
            end

            it "allows superadmin" do
              is_expected.to permit(super_admin, assessment)
            end

            it "allows clinician and admin if they are the author" do
              [clinician, admin].each do |user|
                allow(user).to receive(:id).and_return(1)
                allow(assessment).to receive(:created_by_id).and_return(1)
                is_expected.to permit(user, assessment)
              end
            end

            it "disallows clinician and admin if they not are the author" do
              [clinician, admin].each do |user|
                allow(user).to receive(:id).and_return(1)
                allow(assessment).to receive(:created_by_id).and_return(2)
                is_expected.not_to permit(user, assessment)
              end
            end
          end

          context "when the deletion window has expired" do
            before do
              Renalware.configure do |config|
                config.new_clinic_visit_deletion_window = 24.hours
              end
            end

            let(:assessment) do
              instance_double(NeedlingAssessment, persisted?: true, created_at: 2.days.ago)
            end

            it "allows superadmin" do
              is_expected.to permit(super_admin, assessment)
            end

            it "disallows clinician and admin if they are the author" do
              [clinician, admin].each do |user|
                allow(user).to receive(:id).and_return(1)
                allow(assessment).to receive(:created_by_id).and_return(1)
                is_expected.not_to permit(user, assessment)
              end
            end

            it "disallows clinician and admin if they not are the author" do
              [clinician, admin].each do |user|
                allow(user).to receive(:id).and_return(1)
                allow(assessment).to receive(:created_by_id).and_return(2)
                is_expected.not_to permit(user, assessment)
              end
            end
          end
        end
      end
    end
  end
end
