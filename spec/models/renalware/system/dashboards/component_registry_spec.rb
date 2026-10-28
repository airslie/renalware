module Renalware
  describe System::Dashboards::ComponentRegistry do
    describe ".fetch" do
      it "returns the class for a registered name" do
        expect(described_class.fetch("Renalware::System::UserActivityComponent"))
          .to eq(System::UserActivityComponent)
      end

      it "returns nil for an unregistered name" do
        expect(described_class.fetch("Kernel")).to be_nil
      end
    end

    describe ".class_names" do
      it "is true for the admin dashboard components" do
        expect(described_class.class_names).to include(
          "Renalware::System::UserActivityComponent",
          "Renalware::Monitoring::Mirth::IntegrationActivityComponent",
          "Renalware::System::UsersAwaitingApprovalComponent"
        )
      end
    end
  end
end
