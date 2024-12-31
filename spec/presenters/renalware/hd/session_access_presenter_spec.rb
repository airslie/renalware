describe Renalware::HD::SessionAccessPresenter do
  subject(:presenter) { described_class }

  def mock_session(access_type: "ABC",
                   access_type_abbreviation: "A",
                   access_side: "right")
    instance_double(
      Renalware::HD::Session,
      document: instance_double(
        Renalware::HD::SessionDocument,
        info: instance_double(
          Renalware::HD::SessionDocument::Info,
          access_type: access_type,
          access_type_abbreviation: access_type_abbreviation,
          access_side: access_side
        )
      )
    )
  end

  describe "#to_s" do
    it "handles a nil session" do
      expect(presenter.new(nil).to_s).to eq("")
    end

    it "handles a nil session.document" do
      session = instance_double(Renalware::HD::Session, document: nil)

      expect(presenter.new(session).to_s).to eq("")
    end

    it "returns only the access_type is that's all there is" do
      session = mock_session(access_side: nil)

      expect(presenter.new(session).to_s).to eq("ABC")
    end

    it "returns only the access_side is that's all there is" do
      session = mock_session(access_type: nil)

      expect(presenter.new(session).to_s).to eq("Right")
    end

    it "concatenates all access fields if present" do
      expect(presenter.new(mock_session).to_s).to eq("ABC<br/>Right")
    end
  end

  describe "#to_html" do
    it "handles a nil session" do
      expect(presenter.new(nil).to_html).to eq("")
    end

    it "handles a nil session.document" do
      session = instance_double(Renalware::HD::Session, document: nil)

      expect(presenter.new(session).to_html).to eq("")
    end

    it "uses the abbreviated access_type" do
      session = mock_session(access_side: nil)

      expect(presenter.new(session).to_html).to eq("A")
    end

    it "concatenates all access fields if present" do
      expect(presenter.new(mock_session).to_html).to eq("A/R")
    end
  end
end
