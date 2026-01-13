module Renalware::Patients
  describe Practice do
    it :aggregate_failures do
      is_expected.to validate_presence_of :name
      is_expected.to validate_presence_of :address
      is_expected.to validate_presence_of :code
      is_expected.to have_many(:practice_memberships)
      is_expected.to have_many(:primary_care_physicians).through(:practice_memberships)
    end

    describe "#default_primary_care_physician" do
      it "returns the default when one has been previously set" do
        practice = create(:practice)
        default_physician = create(:primary_care_physician, name: "AAA")
        other_physician1 = create(:primary_care_physician, name: "BBB")
        create(
          :practice_membership,
          practice: practice,
          primary_care_physician: other_physician1
          # default_gp defaults to false by default
        )
        create(
          :practice_membership,
          practice: practice,
          primary_care_physician: default_physician, # will be default de to name
          default_gp: true
        )

        expect(practice.default_primary_care_physician).to eq(default_physician)
        expect(practice.primary_care_physicians.count).to eq(2)
      end

      it "assigns and returns the generic GP when none has been set" do
        practice = create(:practice)

        default_gp = practice.default_primary_care_physician

        expect(default_gp).to eq(PrimaryCarePhysician.generic)
        expect(practice.primary_care_physicians.count).to eq(1)
        expect(practice.practice_memberships.count).to eq(1)
        expect(practice.practice_memberships.first.default_gp).to be(true)
      end
    end
  end
end
