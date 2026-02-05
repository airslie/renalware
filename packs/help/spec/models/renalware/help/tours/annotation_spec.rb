module Renalware
  describe Help::Tours::Annotation do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:attached_to_selector)
      is_expected.to belong_to(:page)
    end

    describe "uniqueness" do
      subject { described_class.new(attached_to_selector: "foo", page: page, text: "ABC") }

      let(:page) { Help::Tours::Page.create!(route: "/") }

      it do
        is_expected
          .to validate_uniqueness_of(:attached_to_selector)
          .scoped_to(:page_id)
      end
    end
  end
end
