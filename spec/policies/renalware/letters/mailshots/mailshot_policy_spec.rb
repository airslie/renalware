module Renalware
  module Letters
    module Mailshots
      describe MailshotPolicy, type: :policy do
        include PolicySpecHelper
        include PatientsSpecHelper
        subject { described_class }

        let(:clinician)   { user_double_with_role(:clinical) }
        let(:admin)       { user_double_with_role(:admin) }
        let(:super_admin) { user_double_with_role(:super_admin) }
        let(:mailshot)    { Mailshot.new }

        %i(new? create?).each do |permission|
          permissions permission do
            it do
              is_expected.not_to permit(clinician, mailshot)
              is_expected.not_to permit(admin, mailshot)
              is_expected.to permit(super_admin, mailshot)
            end
          end
        end

        %i(index?).each do |permission|
          permissions permission do
            it do
              is_expected.not_to permit(clinician, mailshot)
              is_expected.to permit(admin, mailshot)
              is_expected.to permit(super_admin, mailshot)
            end
          end
        end
      end
    end
  end
end
