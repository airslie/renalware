module Renalware::Medications
  describe Review do
    it_behaves_like "an Accountable model"

    it :aggregate_failures do
      is_expected.to belong_to :patient
      is_expected.to validate_presence_of :patient
    end

    describe ".latest" do
      it "returns the last review event for the patient" do
        event_type = create(:medication_review_event_type)
        user = create(:user)
        patient = create(:patient, by: user)

        target_review = described_class.create!(
          patient: patient,
          by: user,
          date_time: 1.day.ago,
          event_type: event_type
        )

        described_class.create!(
          patient: patient,
          by: user,
          date_time: 2.days.ago,
          event_type: event_type
        )

        expect(patient.medication_reviews.latest).to eq(target_review)
      end

      [
        {
          max_months: "6", # check it can handle a string
          review_date: 6.months.ago,
          result: true
        },
        {
          max_months: 5,
          review_date: 5.months.ago,
          result: true
        },
        {
          max_months: 4,
          review_date: 1.day.ago,
          result: true
        },
        {
          max_months: 1,
          review_date: 2.months.ago,
          result: false
        },
        {
          max_months: nil, # will default to 24
          review_date: 6.months.ago,
          result: true
        },
        {
          max_months: nil, # will default to 24
          review_date: 25.months.ago,
          result: false
        }
      ].each do |opts|
        context "when review_date=#{opts[:review_date]} & config max months=#{opts[:max_months]}" do
          it "returns #{opts[:result]}" do
            user = create(:user)
            patient = create(:patient, by: user)
            create(
              :medication_review,
              patient: patient,
              date_time: opts[:review_date],
              by: user
            )
            allow(Renalware.config)
              .to receive(:medication_review_max_age_in_months)
              .and_return(opts[:max_months])

            latest = patient.medication_reviews.latest

            expect(latest.present?).to eq(opts[:result])
          end
        end
      end
    end
  end
end
