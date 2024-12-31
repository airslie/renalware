describe Renalware::Pathology::Requests::RequestQuery do
  let(:params) { {} }
  let(:request_query) { described_class.new(params) }

  describe "#call" do
    subject(:request_query) { described_class.new(params) }

    let!(:clinic) { create(:clinic) }
    let!(:patient) { create(:pathology_patient) }
    let!(:consultant) { create(:consultant) }
    let!(:request_new) do
      create(
        :pathology_requests_request,
        clinic: clinic,
        patient: patient,
        consultant: consultant,
        created_at: 1.day.ago
      )
    end
    let!(:request_old) do
      create(
        :pathology_requests_request,
        clinic: clinic,
        patient: patient,
        consultant: consultant,
        created_at: 2.days.ago
      )
    end

    context "with no filter given in the params" do
      it "shows all requests sorted by the default sort value" do
        expect(request_query.call.map(&:id)).to eq([request_new.id, request_old.id])
      end
    end

    context "with a filter given in the params" do
      let(:date) { request_old.created_at.to_date.strftime("%d-%m-%Y") }
      let(:params) { { created_on_eq: date } }

      it "filters the requests" do
        expect(request_query.call.map(&:id)).to eq([request_old.id])
      end
    end
  end
end
