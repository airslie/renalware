describe Renalware::Letters::Transports::Mesh::ActivityComponent, type: :component do
  describe "#stats" do
    it "returns aggregated transmission counts for each period and status" do
      travel_to(Time.zone.parse("2026-02-20 12:00:00")) do
        create(:letter_mesh_transmission, status: :success, created_at: 2.hours.ago)
        create(:letter_mesh_transmission, status: :pending, created_at: 3.days.ago)
        create(:letter_mesh_transmission, status: :failure, created_at: 20.days.ago)
        create(:letter_mesh_transmission, status: :success, created_at: 40.days.ago)
        create(:letter_mesh_transmission, status: :pending, created_at: 2.months.ago)

        component = described_class.new(current_user: create(:user, :super_admin))

        expect(component.stats).to eq(
          "Today" => { pending: 0, success: 1, failure: 0 },
          "Last 7 days" => { pending: 1, success: 1, failure: 0 },
          "Last month" => { pending: 1, success: 1, failure: 1 },
          "All time" => { pending: 2, success: 2, failure: 1 }
        )
      end
    end
  end
end
