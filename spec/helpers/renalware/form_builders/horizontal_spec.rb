RSpec.describe Renalware::FormBuilders::Horizontal do
  let(:attachment) { build(:patient_attachment) }

  describe "#text_row" do
    it "renders label, control and hint classes" do
      html = helper.form_with(model: attachment, url: "/attachments",
                              builder: described_class) do |f|
        f.text_row(:name, hint: "Used in listings")
      end

      fragment = Nokogiri::HTML.fragment(html)

      expect(fragment.css(".rw-field-row").size).to eq(1)
      expect(fragment.css(".rw-label .rw-label__text").text).to include("Name")
      expect(fragment.css(".rw-control .rw-input").size).to eq(1)
      expect(fragment.css(".rw-hint").text).to include("Used in listings")
    end

    it "renders errors for the field when present" do
      attachment.errors.add(:name, "can't be blank")

      html = helper.form_with(model: attachment, url: "/attachments",
                              builder: described_class) do |f|
        f.text_row(:name)
      end

      fragment = Nokogiri::HTML.fragment(html)

      expect(fragment.css(".rw-error").text).to include("can't be blank")
    end

    it "applies semantic size class when provided" do
      html = helper.form_with(model: attachment, url: "/attachments",
                              builder: described_class) do |f|
        f.text_row(:name, size: :sm)
      end

      fragment = Nokogiri::HTML.fragment(html)
      input = fragment.at_css("input.rw-input")

      expect(input["class"]).to include("rw-input--sm")
    end
  end

  describe "#error_summary" do
    it "renders summary when there are errors" do
      attachment.errors.add(:name, "can't be blank")

      html = helper.form_with(model: attachment, url: "/attachments",
                              builder: described_class, &:error_summary)

      fragment = Nokogiri::HTML.fragment(html)

      expect(fragment.css(".rw-error-summary").size).to eq(1)
      expect(fragment.css(".rw-error-summary__list li").text).to include("Name can't be blank")
    end
  end

  describe "#date_row" do
    it "attaches the flatpickr stimulus controller and formatted value" do
      attachment.document_date = Date.new(2026, 2, 1)

      html = helper.form_with(model: attachment, url: "/attachments",
                              builder: described_class) do |f|
        f.date_row(:document_date)
      end

      fragment = Nokogiri::HTML.fragment(html)
      input = fragment.at_css("input.rw-input")
      icon_wrapper = fragment.at_css(".rw-date-input")
      icon = fragment.at_css(".rw-date-input__icon")
      svg = fragment.at_css(".rw-date-input__icon-svg")

      expect(input["data-controller"]).to eq("flatpickr")
      expect(input["autocomplete"]).to eq("off")
      expect(input["value"]).to be_present
      expect(input["class"]).to include("rw-input--date")
      expect(input["class"]).to include("rw-input--with-icon")
      expect(icon_wrapper).to be_present
      expect(icon).to be_present
      expect(icon["aria-hidden"]).to eq("true")
      expect(svg).to be_present
    end
  end
end
