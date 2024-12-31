module Renalware
  describe Dietetics::VisitsComponent, type: :component do
    let(:patient) { Patient.new(id: 12) }
    let(:instance) { described_class.new(patient: patient) }

    context "with no clinic visits" do
      it "renders empty table" do
        render_inline(instance)

        expect(instance.render?).to be(true)
        expect(page).to have_content("Dietetic Visits")
        expect(page).to have_content("0 of 0")
      end
    end

    # Can't figure out how to stub/inject `current_user` as used by the views
    # app/views/renalware/clinics/clinic_visits/_table_row.html.slim

    # context "with one dietetic clinic visit" do
    #   let(:instance) {
    #     described_class.new(
    #       patient: patient,
    #       dietetic_clinic_visits_loader: proc { [dietetic_clinic] })
    #   }
    #   let(:user) { User.new }

    #   before do
    #     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    #   end

    #   context "with full data" do
    #     let(:dietetic_clinic) {
    #       Dietetics::ClinicVisit.new(
    #         date: Date.parse("2022-10-11"),
    #         weight: 72
    #       )
    #     }

    #     it "renders table data" do
    #       render_inline(instance)

    #       expect(instance.render?).to be(true)

    #       expect(page).to have_content("Dietetic Visits")
    #       expect(page).to have_content("1 of 1")
    #     end
    #   end

    #   context "with no data" do
    #     let(:dietetic_clinic) { Dietetics::ClinicVisit.new }

    #     it "renders mostly empty" do
    #       render_inline(instance)

    #       expect(instance.render?).to be(true)

    #       expect(page).to have_content("Dietetic Visits")
    #       expect(page).to have_content("1 of 1")
    #     end
    #   end
    # end
  end
end
