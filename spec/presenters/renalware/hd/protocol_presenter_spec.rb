describe Renalware::HD::ProtocolPresenter do
  include PathologySpecHelper

  let(:user) { create(:user) }

  before do
    allow(Renalware.config).to receive(:hd_session_form_prescription_days_lookahead).and_return(8)
  end

  describe "methods" do
    subject(:presenter) { described_class.new(nil, nil) }

    let(:patient) { nil }
    let(:user) { create(:user) }

    it :aggregate_failures do
      is_expected.to respond_to(:preference_set)
      is_expected.to respond_to(:access)
      is_expected.to respond_to(:sessions)
      is_expected.to respond_to(:patient_title)
      is_expected.to respond_to(:prescriptions)
      is_expected.to respond_to(:recent_pathology)
      is_expected.to respond_to(:latest_dry_weight)
    end
  end

  describe "#prescriptions" do
    it "returns prescriptions to be administered on HD that are " \
       "current or have a future start date within the next configured x days eg 8" do
      patient = create(:hd_patient)
      prescriptions = {
        hd_current: create(
          :prescription,
          patient: patient,
          administer_on_hd: true,
          prescribed_on: 1.day.ago
        ),
        non_hd_current: create(
          :prescription,
          patient: patient,
          administer_on_hd: false
        ),
        hd_starting_7d_hence: create(
          :prescription,
          patient: patient,
          administer_on_hd: true,
          prescribed_on: 7.days.since
        ),
        hd_starting_9d_hence: create(
          :prescription,
          patient: patient,
          administer_on_hd: true,
          prescribed_on: 9.days.since
        ),
        hd_terminated: create(
          :prescription,
          patient: patient,
          administer_on_hd: true,
          prescribed_on: 2.days.ago
        ).tap { |ps| ps.build_termination(terminated_on: 1.day.ago, by: user).save! }
      }

      presenter = described_class.new(patient, nil)

      expect(presenter.prescriptions.map(&:id)).to eq(
        [
          prescriptions[:hd_current].id,
          prescriptions[:hd_starting_7d_hence].id
        ]
      )
    end
  end

  describe "#latest_dry_weight" do
    it "returns the latest dry weight" do
      patient = create(:clinical_patient)
      create(:dry_weight, patient: patient, weight: 123, assessed_on: 1.year.ago)
      newer = create(:dry_weight, patient: patient, weight: 234, assessed_on: 1.day.ago)
      presenter = described_class.new(patient, nil)

      expect(presenter.latest_dry_weight).to eq(newer)
    end
  end

  describe "#recent_pathology" do
    context "when the patient has recent pathology" do
      it "returns the current_observation_set.values hash" do
        # Because the AllObservationCodes singleton might already have been instantiated
        # and hanging onto a previous collection of observation codes, reset it
        Singleton.__init__(Renalware::Pathology::AllObservationCodes)
        descriptions = create_descriptions(%w(HGB PLT CRP))
        patient = create(:pathology_patient)

        # For this test to pass we need to have created a Pathology::CodeGroup called
        # hd_session_form_recent which has the required OBX members.
        # This code group is the standard one used in the HD Protocol for recent path.
        # A hospital can add whatever codes they like into it.
        user = create(:user)
        group = create(:pathology_code_group, :hd_session_form_recent, by: user)
        descriptions.each do |desc|
          create(
            :pathology_code_group_membership,
            code_group: group,
            observation_description: desc,
            by: user
          )
        end

        time = Time.zone.parse("2017-12-12 01:01:01")

        # This creates two observations and a pg trigger will update patient.current_observation_set
        create_observations(patient,
                            descriptions,
                            observed_at: time,
                            result: 1)

        presenter = described_class.new(patient, nil)

        recent_path = presenter.recent_pathology
        expect(recent_path.hgb_result).to eq("1")
        expect(recent_path.hgb_observed_at).to eq(time.to_date)
        expect(recent_path.plt_result).to eq("1")
        expect(recent_path.plt_observed_at).to eq(time.to_date)
        expect(recent_path.crp_result).to eq("1")
        expect(recent_path.crp_observed_at).to eq(time.to_date)
      end
    end
  end

  context "when the patient has no pathology" do
    it "returns an empty current_observation_set so eg a #hgb_result call will not fail" do
      # Because the AllObservationCodes singleton might already have been instantiated
      # and hanging onto a previous collection of observation codes, reset it
      Singleton.__init__(Renalware::Pathology::AllObservationCodes)
      # Important - we need to create the relevant observation descriptions e.g. HGB before we can
      # try and access it on the current_observations_set.values hash (eg #hgb_result) which
      # uses .method_missing to dynamically find the relevant result.
      create_descriptions(%w(HGB PLT CRP))

      patient = create(:pathology_patient)
      presenter = described_class.new(patient, nil)

      recent_path = presenter.recent_pathology
      expect(recent_path.hgb_result).to be_nil
      expect(recent_path.hgb_observed_at).to be_nil
      expect(recent_path.plt_result).to be_nil
      expect(recent_path.plt_observed_at).to be_nil
      expect(recent_path.crp_result).to be_nil
      expect(recent_path.crp_observed_at).to be_nil
    end
  end
end
