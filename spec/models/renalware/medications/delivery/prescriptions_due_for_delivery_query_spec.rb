# frozen_string_literal: true

module Renalware::Medications::Delivery
  describe PrescriptionsDueForDeliveryQuery do
    subject(:query) { described_class.new.call }

    def create_home_del_prescription(patient, drug, next_delivery_date)
      create(
        :prescription,
        patient: patient,
        drug: drug,
        provider: :home_delivery,
        next_delivery_date: next_delivery_date
      )
    end

    context "when there are no prescriptions" do
      it { is_expected.to eq [] }
    end

    context "when there are no current home delivery prescriptions" do
      it "returns an empty relation" do
        create(:prescription, provider: :gp)

        expect(query).to eq []
      end
    end

    it "defaults @from to be the beginning of the day 4 weeks ago" do
      travel_to Date.parse("28-01-2020") do
        expect(described_class.new.from).to be_a(Time)
        expect(described_class.new.from).to eq(Time.zone.parse("31-12-2019 00:00:00"))
      end
    end

    it "defaults @to to be the end of the day 2 from now" do
      travel_to Date.parse("01-01-2020") do
        expect(described_class.new.to).to be_a(Time)
        expect(described_class.new.to).to eq(Time.zone.parse("15-01-2020 23:59:59.999999999"))
      end
    end

    context "when there are current home delivery prescriptions" do
      it "only selects them if they are within the supplied date range" do
        travel_to Date.parse("01-01-2020") do
          patient = create(:patient, family_name: "JONES")
          drug = create(:drug)

          prescriptions = [
            create_home_del_prescription(patient, drug, 2.weeks.from_now),
            create_home_del_prescription(patient, drug, 15.days.from_now),
            create_home_del_prescription(patient, drug, 4.weeks.ago),
            create_home_del_prescription(patient, drug, 5.weeks.ago)
          ]

          results = described_class.new.call
          expect(results.length).to eq(2)
          expect(results.map(&:id)).to eq(
            [
              prescriptions[2].id,
              prescriptions[0].id
            ]
          )
        end
      end

      it "excludes terminated prescriptions" do
        travel_to Date.parse("01-01-2020") do
          patient = create(:patient, family_name: "JONES")
          drug = create(:drug)

          prescription = create_home_del_prescription(patient, drug, 2.weeks.from_now)
          create(
            :prescription_termination,
            prescription: prescription,
            terminated_on: 1.day.ago
          )

          results = described_class.new.call
          expect(results.length).to eq(0)
        end
      end
    end

    context "when a drug type code is supplied" do
      it "only relevant prescriptions having a drug of that drug type" do
        travel_to Date.parse("01-01-2020") do
          patient = create(:patient)
          esa_drug_type = create(:drug_type, :esa)
          immuno_drug_type = create(:drug_type, :immunosuppressant)
          esa_drug = create(:drug, name: "esa drug").tap { |drug| drug.drug_types << esa_drug_type }
          immuno_drug =
            create(:drug, name: "drug2").tap { |drug| drug.drug_types << immuno_drug_type }

          prescriptions = [
            create_home_del_prescription(patient, esa_drug, 1.week.from_now),
            create_home_del_prescription(patient, immuno_drug, 1.day.from_now)
          ]

          results = described_class.new(drug_type_code: :esa).call
          expect(results.length).to eq(1)
          expect(results.map(&:id)).to eq([prescriptions[0].id])
        end
      end
    end
  end
end
