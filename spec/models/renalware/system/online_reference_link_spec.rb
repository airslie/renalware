# frozen_string_literal: true

describe Renalware::System::OnlineReferenceLink do
  let(:user) { create(:user) }

  it :aggregate_failures do
    is_expected.to validate_presence_of(:url)
    is_expected.to validate_presence_of(:title)
  end

  describe "uniqueness" do
    subject { described_class.new(url: "X", title: "Y", created_by: user, updated_by: user) }

    it :aggregate_failures do
      is_expected.to validate_uniqueness_of(:url)
      is_expected.to validate_uniqueness_of(:title)
    end
  end

  describe "url format validation" do
    it :aggregate_failures do
      is_expected.to allow_value("https://abc123.com?1$=*7*&@£$%^&").for(:url)
      is_expected.to allow_value("http://abc123.com").for(:url)
      is_expected.not_to allow_value("xhttp://abc123.com").for(:url)
      is_expected.not_to allow_value("http:/abc123.com").for(:url)
    end

    it "message" do
      expect(
        described_class.new(url: "xx").tap(&:valid?).errors[:url]&.first
      ).to eq("must start with http:// or https://")
    end
  end

  describe "include_in_letters_from, include_in_letters_to" do
    it "validates that include_in_letters_until cannot be before include_in_letters_from" do
      link = described_class.new(
        include_in_letters_from: "2024-01-02",
        include_in_letters_until: "2024-01-01"
      ).tap(&:valid?)

      expect(link.errors[:include_in_letters_until])
        .to eq(["cannot be before the from date"])
    end

    it "validates presence of 'from' if 'until' is present" do
      link = described_class.new(
        include_in_letters_from: nil,
        include_in_letters_until: "2024-01-01"
      ).tap(&:valid?)

      expect(link.errors[:include_in_letters_from]).to eq(["can't be blank"])
    end

    describe "#default_in_new_letters scope" do
      let(:user) { create(:user) }

      it "returns QR links that are configured to be added to new letters at this point in time" do
        travel_to Date.parse("2024-01-01") do
          # expect(described_class.default_in_new_letters).to eq([])

          # Target1
          target1 = described_class.create!(
            include_in_letters_from: 1.day.ago,
            include_in_letters_until: 1.day.from_now,
            url: "https://example1.com",
            title: "1",
            by: user
          )

          # Target2
          target2 = described_class.create!(
            include_in_letters_from: 1.day.ago,
            include_in_letters_until: nil, # forever
            url: "https://example1a.com",
            title: "1a",
            by: user
          )

          # Expired
          described_class.create!(
            include_in_letters_from: 10.days.ago,
            include_in_letters_until: 9.days.ago,
            url: "https://example2.com",
            title: "2",
            by: user
          )

          # Future
          described_class.create!(
            include_in_letters_from: 1.day.from_now,
            include_in_letters_until: nil, # forever
            url: "https://example3.com",
            title: "3",
            by: user
          )

          # No dates so out of the picture
          described_class.create!(
            include_in_letters_from: nil,
            include_in_letters_until: nil,
            url: "https://example4.com",
            title: "4",
            by: user
          )

          expect(described_class.default_in_new_letters).to eq([target1, target2])
        end
      end
    end
  end
end
