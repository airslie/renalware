module Renalware
  module Transplants
    describe RecipientWorkup do
      it_behaves_like "an Accountable model"
      it { is_expected.to belong_to(:patient).touch(true) }
      it { is_expected.to be_versioned }
    end
  end
end
