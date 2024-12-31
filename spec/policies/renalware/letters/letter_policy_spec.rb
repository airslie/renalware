module Renalware::Letters
  # rubocop:disable RSpec/RepeatedExample
  describe LetterPolicy, type: :policy do
    include PolicySpecHelper
    subject(:policy) { described_class }

    let(:super_admin_user) { user_double_with_role(:super_admin) }
    let(:admin_user) { user_double_with_role(:admin) }
    let(:clinical_user) { user_double_with_role(:clinical) }
    let(:read_only_user) { user_double_with_role(:read_only) }

    permissions :author? do
      it { is_expected.to permit(super_admin_user) }
      it { is_expected.to permit(admin_user) }
      it { is_expected.to permit(clinical_user) }
      it { is_expected.not_to permit(read_only_user) }
    end

    permissions :deleted? do
      it { is_expected.to permit(super_admin_user) }
      it { is_expected.not_to permit(admin_user) }
      it { is_expected.not_to permit(clinical_user) }
      it { is_expected.not_to permit(read_only_user) }
    end

    permissions :destroy? do
      %i(Draft PendingReview).each do |letter_klass|
        context "when the letter is #{letter_klass}" do
          let(:letter) { "Renalware::Letters::Letter::#{letter_klass}".constantize.new }

          context "when the user is the author" do
            let(:user) { clinical_user }

            before { allow(letter).to receive(:author).and_return(user) }

            it { is_expected.to permit(user, letter) }
          end

          context "when the user is the creator" do
            let(:user) { clinical_user }

            before { allow(letter).to receive(:created_by).and_return(user) }

            it { is_expected.to permit(user, letter) }
          end

          context "when the user is a admin" do
            let(:user) { admin_user }

            it { is_expected.to permit(user, letter) }
          end

          context "when the user is a super admin" do
            let(:user) { super_admin_user }

            it { is_expected.to permit(user, letter) }
          end

          context "when the user is a clinical_user and not the creator or author" do
            let(:user) { clinical_user }

            it { is_expected.not_to permit(user, letter) }
          end

          context "when the user is read-only" do
            let(:user) { read_only_user }

            it { is_expected.not_to permit(user, letter) }
          end
        end
      end

      # In these states the letter can only be (soft-) deleted by a superadmin
      %i(Approved Completed).each do |letter_klass|
        context "when the letter is #{letter_klass}" do
          let(:letter) { "Renalware::Letters::Letter::#{letter_klass}".constantize.new }

          context "when the user is a superadmin" do
            let(:user) { super_admin_user }

            it "superadmin can soft-delete letters" do
              is_expected.to permit(user, letter)
            end
          end

          context "when the user is the author" do
            let(:user) { clinical_user }

            before { allow(letter).to receive(:author).and_return(user) }

            it { is_expected.not_to permit(user, letter) }
          end

          context "when the user is a admin" do
            let(:user) { admin_user }

            it { is_expected.not_to permit(user, letter) }
          end
        end
      end
    end
  end
  # rubocop:enable RSpec/RepeatedExample
end
