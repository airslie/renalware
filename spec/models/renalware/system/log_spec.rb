module Renalware
  describe System::Log do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:severity)
      is_expected.to validate_presence_of(:group)
      is_expected.to respond_to(:info?)
    end

    describe "#info" do
      it "creates a info log" do
        described_class.info("Test")

        expect(described_class.last).to have_attributes(
          message: "Test",
          severity: "info",
          group: "admin"
        )
      end

      it "creates an info log with group" do
        described_class.info("Test", group: :users)

        expect(described_class.last).to have_attributes(
          message: "Test",
          severity: "info",
          group: "users"
        )
      end
    end

    describe "#warning" do
      it "creates a log" do
        described_class.warning("Test")

        expect(described_class.last).to have_attributes(
          message: "Test",
          severity: "warning",
          group: "admin"
        )
      end

      it "creates an info log with group" do
        described_class.warning("Test", group: :users)

        expect(described_class.last).to have_attributes(
          message: "Test",
          severity: "warning",
          group: "users"
        )
      end
    end

    describe "#error" do
      it "creates a log" do
        described_class.error("Test")

        expect(described_class.last).to have_attributes(
          message: "Test",
          severity: "error",
          group: "admin"
        )
      end

      it "creates an info log with group" do
        described_class.error("Test", group: :users)

        expect(described_class.last).to have_attributes(
          message: "Test",
          severity: "error",
          group: "users"
        )
      end
    end
  end
end
