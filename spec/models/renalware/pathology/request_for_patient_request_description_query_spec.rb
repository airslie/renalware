describe Renalware::Pathology::RequestForPatientRequestDescriptionQuery do
  let(:clinic) { create(:clinic) }
  let(:patient) { create(:pathology_patient) }
  let(:consultant) { create(:consultant) }
  let(:request_description) { create(:pathology_request_description, code: "XYZ") }
  let(:request_description_unrelated) { create(:pathology_request_description, code: "ABC") }

  let(:request_newest_but_unrelated) do
    create(
      :pathology_requests_request,
      clinic: clinic,
      patient: patient,
      consultant: consultant,
      request_descriptions: [request_description_unrelated],
      created_at: Time.zone.now
    )
  end
  let(:request_new) do
    create(
      :pathology_requests_request,
      clinic: clinic,
      patient: patient,
      consultant: consultant,
      request_descriptions: [request_description],
      created_at: 1.day.ago
    )
  end
  let(:request_old) do
    create(
      :pathology_requests_request,
      clinic: clinic,
      patient: patient,
      consultant: consultant,
      request_descriptions: [request_description],
      created_at: 2.days.ago
    )
  end

  let(:query) do
    described_class.new(patient, request_description)
  end

  describe "#call" do
    subject(:resulting_request_date) { query.call }

    it do
      request_newest_but_unrelated
      request_new
      request_old

      expect(resulting_request_date.to_date).to eq(request_new.created_at.to_date)
    end
  end
end
