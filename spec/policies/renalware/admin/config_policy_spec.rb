module Renalware
  module Admin
    # rubocop:disable RSpec/RepeatedExample
    describe ConfigPolicy, type: :policy do
      include PolicySpecHelper

      subject(:policy) { described_class }

      let(:admin)       { user_double_with_role(:admin) }
      let(:super_admin) { user_double_with_role(:super_admin) }

      %i(edit? update? destroy?).each do |permission|
        permissions permission do
          it { is_expected.not_to permit(super_admin) }
          it { is_expected.not_to permit(admin) }
        end
      end

      %i(show?).each do |permission|
        permissions permission do
          it { is_expected.not_to permit(admin) }
          it { is_expected.to permit(super_admin) }
        end
      end
    end
    # rubocop:enable RSpec/RepeatedExample
  end
end
