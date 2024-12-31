module Renalware
  class MDMPresenter
    NullAccess = Naught.build do |config|
      config.black_hole
      config.define_explicit_conversions
      config.singleton
      config.predicates_return false
    end

    attr_reader :patient, :view_context

    def initialize(patient:, view_context:)
      @patient = patient
      @view_context = view_context
    end

    def pathology_code_group_name
      :default
    end

    def pathology
      Pathology::CreateObservationsGroupedByDateTable2.new(
        patient: patient,
        code_group_name: pathology_code_group_name,
        page: 1,
        per_page: 8
      ).call
    end

    def clinic_visits(limit: 6)
      @clinic_visits ||= begin
        visits_ = Clinics::ClinicVisit
          .for_patient(patient)
          .includes(:clinic)
          .with_created_by
          .ordered
          .limit(limit)
        CollectionPresenter.new(visits_, Renalware::Clinics::VisitPresenter)
      end
    end

    def clinic_visits_having_measurements(limit: 3)
      @clinic_visits_having_measurements ||= begin
        Clinics::ClinicVisit
          .for_patient(patient)
          .where("height is not null " \
                 "or weight is not null " \
                 "or systolic_bp is not null " \
                 "or diastolic_bp is not null")
          .ordered
          .limit(limit)
      end
    end

    def historical_prescriptions
      @historical_prescriptions ||= execute_prescriptions_query(patient.prescriptions)
    end

    def current_prescriptions
      @current_prescriptions ||= begin
        execute_prescriptions_query(patient.prescriptions.current)
      end
    end

    def current_immunosuppressant_prescriptions
      @current_immunosuppressant_prescriptions ||= begin
        execute_prescriptions_query(
          patient.prescriptions.having_drug_of_type(:immunosuppressant).current
        )
      end
    end

    def historical_immunosuppressant_prescriptions
      @historical_immunosuppressant_prescriptions ||= begin
        execute_prescriptions_query(
          patient.prescriptions.having_drug_of_type(:immunosuppressant)
        )
      end
    end

    # Note we sort prescriptions by prescribed_on desc here manually because the
    # prescriptions query is currently too complex to add another sql sort into (defaults)
    # to sorting by drug name
    def esa_prescriptions
      @esa_prescriptions ||= begin
        execute_prescriptions_query(
          patient.prescriptions.having_drug_of_type("esa")
        ).sort_by(&:prescribed_on).reverse!
      end
    end

    # Note we sort prescriptions by prescribed_on desc here manually because the
    # prescriptions query is currently too complex to add another sql sort into (defaults)
    # to sorting by drug name
    def bone_prescriptions
      @bone_prescriptions ||= begin
        execute_prescriptions_query(
          patient.prescriptions.having_drug_of_type("bone/Ca/PO4")
        ).sort_by(&:prescribed_on).reverse!
      end
    end

    def current_problems
      @current_problems ||= patient.problems.current.limit(6).with_created_by.ordered
    end

    # rubocop:disable Lint/UnusedMethodArgument
    def events_of_type(type: nil)
      events_ = Events::Event
        .for_patient(patient)
        .includes([:created_by, :patient, event_type: :category])
        .limit(6)
        .ordered
      CollectionPresenter.new(events_, Renalware::Events::EventPresenter)
    end
    # rubocop:enable Lint/UnusedMethodArgument
    alias events events_of_type

    def letters
      patient_ = Renalware::Letters.cast_patient(patient)
      letters_ = patient_
        .letters
        .ordered
        .with_main_recipient
        .with_letterhead
        .with_author
        .with_event
        .with_patient
        .limit(6)

      CollectionPresenter.new(letters_, Renalware::Letters::LetterPresenterFactory)
    end

    def current_pathology_for_code(code)
      result = OpenStruct.new(value: nil, date: nil)
      hash = patient.current_observation_set&.values_for_codes(code) || {}
      obs = hash[code]
      if obs.present?
        result.value = obs["result"]
        result.date = obs["observed_at"]
        result.date = Date.parse(result.date)
      end
      result
    end

    def current_transplant_status
      @current_transplant_status ||= Transplants.current_transplant_status_for_patient(patient)
    end

    def access
      @access ||= begin
        access_profile = Renalware::Accesses.cast_patient(patient).current_profile
        if access_profile.present?
          Accesses::ProfilePresenter.new(access_profile)
        else
          NullAccess.instance
        end
      end
    end

    private

    def pathology_patient
      Renalware::Pathology.cast_patient(patient)
    end

    def execute_prescriptions_query(relation)
      query = Medications::PrescriptionsQuery.new(relation: relation)
      query
        .call
        .with_created_by
        .with_medication_route
        .with_drugs
        .with_classifications
        .eager_load(drug: [:drug_types])
        .map { |prescrip| Medications::PrescriptionPresenter.new(prescrip) }
    end
  end
end
