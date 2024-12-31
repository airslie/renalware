module Renalware
  module Accesses
    describe NeedlingAssessment do
      it_behaves_like "an Accountable model"
      it { is_expected.to have_db_index(%i(patient_id created_at)) }
      it { is_expected.to belong_to(:patient) }
      it { is_expected.to validate_presence_of(:difficulty) }
      it { is_expected.to validate_presence_of(:patient) }

      describe "#difficulty (enum)" do
        it :aggregate_failures do
          %i(easy? moderate? hard? easy!).each do |method|
            is_expected.to respond_to(method)
          end
        end
      end

      describe "#latest" do
        it "returns the last added record" do
          patient = create(:accesses_patient)
          {
            "2022-05-01" => :easy,
            "2022-06-01" => :moderate,
            "2022-02-01" => :hard
          }.each do |date, difficulty|
            create(
              :access_needling_assessment,
              patient: patient,
              difficulty: difficulty,
              created_at: Time.zone.parse(date)
            )
          end

          expect(patient.needling_assessments.latest).to have_attributes(
            difficulty: "moderate",
            created_at: Time.zone.parse("2022-06-01")
          )
        end
      end
    end
  end
end
