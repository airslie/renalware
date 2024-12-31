module Renalware
  module Letters
    describe TopicsPresenter do
      let(:insta) { ContactPresenter.new }

      let(:contact) { build(:letter_contact) }

      describe ".list_for_dropdown" do
        let!(:topic) { create(:letter_topic, text: "Topic") }

        it "returns a list with data attributes for frame url" do
          result = described_class.list_for_dropdown("http://url/REPLACE_ID")

          expect(result.size).to eq 1

          option = result[0]
          expect(option[0]).to eq "Topic"
          expect(option[1]).to eq topic.id
          expect(option[2][:data][:frame_url]).to eq "http://url/#{topic.id}"
        end
      end
    end
  end
end
