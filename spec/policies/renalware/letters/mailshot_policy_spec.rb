# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    module Mailshots
      describe MailshotPolicy, type: :policy do
        include PolicySpecHelper
        include PatientsSpecHelper
        subject { described_class }

        let(:clinician) { user_double_with_role(:clinical) }
        let(:admin) { user_double_with_role(:admin) }
        let(:super_admin) { user_double_with_role(:super_admin) }
        let(:mailshot) { Mailshot.new }

        [:new?, :create?].each do |permission|
          permissions permission do
            it "applies permission correctly", :aggregate_failures do
              is_expected.not_to permit(clinician, mailshot)
              is_expected.not_to permit(admin, mailshot)
              is_expected.to permit(super_admin, mailshot)
            end
          end
        end

        [:index?].each do |permission|
          permissions permission do
            it "applies index permission correctly", :aggregate_failures do
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
