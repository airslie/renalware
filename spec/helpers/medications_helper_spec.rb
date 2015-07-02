require 'rails_helper'

RSpec.describe MedicationsHelper, :type => :helper do
  before do
    @patient = FactoryGirl.create(:patient)
    @med_route = FactoryGirl.create(:medication_route)
    @blue_pill = FactoryGirl.create(:drug)
    @amoxicillin = FactoryGirl.create(:drug, name: 'Amoxicillin')
    @penicillin = FactoryGirl.create(:drug, name: 'Penicillin')
    @invalid_patient_med = FactoryGirl.build(
                            :medication,
                            patient: @patient,
                            medicatable_id: nil,
                            dose: nil,
                            medication_route_id: nil,
                            frequency: nil,
                            start_date: nil,
                            provider: nil)

    @valid_patient_med = FactoryGirl.build(
                          :medication,
                          patient: @patient,
                          medicatable: @amoxicillin,
                          medicatable_type: 'Drug',
                          dose: '23mg',
                          medication_route: @med_route,
                          frequency: 'PID',
                          start_date: '02/10/2014',
                          provider: 0)
  end

  describe 'medicatable_name' do
    context 'medicatable present' do
      it 'should return name' do
        patient_medication = FactoryGirl.build_stubbed(
          :medication,
          patient: @patient,
          medicatable: @blue_pill
          )

        expect(medicatable_name(patient_medication)).to eq(patient_medication.medicatable.name)
      end
    end

    context 'medicatable not present' do
      it 'should not return name' do
        patient_medication = FactoryGirl.build_stubbed(
          :medication,
          patient: @patient,
          medicatable: nil
          )

        expect(medicatable_name(patient_medication)).to eq(nil)
      end
    end
  end

  describe 'highlight_validation_fail' do
    context 'with errors' do
      it 'should apply hightlight' do
        @invalid_patient_med.save
        expect(highlight_validation_fail(@invalid_patient_med, :medicatable_id)).to eq('field_with_errors')
      end
    end

    context 'with no errors' do
      it 'should not apply highlight' do
        @valid_patient_med.save
        expect(highlight_validation_fail(@valid_patient_med, :medicatable)).to eq(nil)
      end
    end
  end

  describe 'validation_fail' do
    context 'with errors' do
      it 'should apply class "show-form"' do
        @invalid_patient_med.save
        expect(validation_fail(@invalid_patient_med)).to eq('show-form')
      end
    end

    context 'with no errors' do
      it 'should apply class "content"' do
        @valid_patient_med.save
        expect(validation_fail(@valid_patient_med)).to eq('content')
      end
    end
  end

  describe 'default_provider' do
    before do
      @gp = Medication.providers.keys[0]
      @hospital = Medication.providers.keys[1]
    end

    context 'is gp' do
      it 'should return "checked"' do
        expect(default_provider(@gp)).to eq('checked')
      end
    end

    context 'is not gp' do
      it 'should return nil' do
        expect(default_provider(@hospital)).to eq(nil)
      end
    end
  end

end
