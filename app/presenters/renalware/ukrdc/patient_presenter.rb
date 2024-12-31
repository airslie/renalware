module Renalware
  module UKRDC
    class PatientPresenter < SimpleDelegator
      UKRDC_MAX_PHONE_LEN = 80

      attr_reader :changes_since, :changes_up_until

      delegate :prd_description, to: :profile, allow_nil: true
      delegate :code, :term, to: :prd_description, allow_nil: true, prefix: true

      def initialize(patient, changes_since: nil)
        if changes_since.present? && changes_since.is_a?(String)
          changes_since = Time.zone.parse(changes_since)
        end
        # TODO: document what's happening here with dates
        @changes_since = changes_since ||
                         patient.sent_to_ukrdc_at ||
                         Renalware.config.ukrdc_default_changes_since_date
        if @changes_since.blank?
          raise(
            ArgumentError,
            "No date for comparison: patient#sent_to_ukrdc_at and changes_since are nil"
          )
        end
        @changes_up_until = Time.zone.now
        super(patient)
      end

      def language
        return if super.nil? || super.name == "Unknown"

        super
      end

      def modalities
        __getobj__.modalities.order(started_on: :asc, updated_at: :desc)
      end

      def dead?
        current_modality_death?
      end

      def current_modality_hd?
        return false if current_modality.blank?

        current_modality.description.is_a?(Renalware::HD::ModalityDescription)
      end

      # Note we of course only send letters for RPV patients and exclude them for all others.
      def letters
        return ::Renalware::Letters::Letter.none if send_to_rpv == false

        CollectionPresenter.new(
          letters_patient
            .letters
            .approved_or_completed
            .includes(:updated_by, :author, :letterhead, :archive)
            .where("updated_at > ?", changes_since),
          Renalware::Letters::LetterPresenterFactory
        )
      end

      # Use DISTINCT ON (performed_on) and an order(performed_on: :desc) to make sure we only
      # get one hd session per day - the last of the day. This is because currently RW allows
      # a duplicate session to be added, and this occasionally happens.
      def finished_hd_sessions
        hd_patient
          .finished_hd_sessions
          .select("distinct on (hd_sessions.started_at::date) hd_sessions.*")
          .includes(:patient, :dialysate, :updated_by)
          .where("hd_sessions.updated_at > ?", changes_since)
          .order("hd_sessions.started_at::date desc")
      end

      def current_registration_status_rr_code
        @current_registration_status_rr_code ||= begin
          status = transplant_patient.current_registration_status
          status&.description&.rr_code
        end
      end

      def hospital_unit_code
        letter_head.site_code
      end

      def allergies
        clinical_patient
          .allergies
          .where(recorded_at: changes_since..)
      end

      def clinic_visits
        @clinic_visits ||= begin
          visits = clinics_patient
            .clinic_visits
            .where(date: changes_since..)
            .includes(:updated_by)
          CollectionPresenter.new(visits, Clinics::ClinicVisitPresenter)
        end
      end

      def treatments
        @treatments ||= begin
          UKRDC::Treatment.where(patient_id: id).delete_all
          UKRDC::TreatmentTimeline::GenerateTimeline.new(self).call
          UKRDC::Treatment.where(patient_id: id).order(:patient_id, :started_on)
        end
      end

      # We always send the patients current prescriptions.
      # Because the XSD rejects non-numeric dose amounts, only send prescriptions with a
      # dose_amount of eg 10 or 10.23 or .23
      def prescriptions_with_numeric_dose_amount
        __getobj__
          .prescriptions
          .includes(:termination, :medication_route, :drug)
          .where("dose_amount ~ '^[ ]*(\\d+|\\d+\\.\\d+|\\.\\d+)[ ]*$'")
          .order(:prescribed_on)
      end

      def observation_requests
        requests = UKRDC::PathologyObservationRequestsQuery.new(
          patient_id: id,
          changes_since: changes_since
        ).call
        CollectionPresenter.new(requests, UKRDC::PathologyObservationRequestPresenter)
      end

      # Return comorbidities marked as Yes.
      # UKRDC expects a date time and we only have the year, so convert to midnight Jan 1
      def yes_comorbidities
        comorbidity_attributes.each_with_object([]) do |attr, arr|
          name, value = attr
          next unless value.respond_to?(:confirmed_on_year) && value.status == "yes"

          arr << OpenStruct.new(
            name: comorbidities.class.human_attribute_name(name),
            date: comorbidity_date_time_from_year(value.confirmed_on_year),
            code: comorbidities.class.snomed_code_for(name)
          )
        end
      end

      def snomed_smoking_history
        return unless smoking_history?

        OpenStruct.new(clinical_history.smoking_snomed)
      end

      def rr_smoking_history
        return unless smoking_history?

        clinical_history.smoking_rr
      end

      def clinical_history
        @clinical_history ||= document&.history || NullObject.instance
      end

      def smoking_history?
        clinical_history.smoking.present?
      end

      def smoking_cormbidity
        comorbidity_attributes[:smoking]
      end

      def profile
        renal_patient.profile || Renalware::Renal::Profile.new
      end

      def first_seen_on
        return if profile.first_seen_on.blank?

        profile.first_seen_on.to_time.iso8601
      end

      def esrf_on
        return if profile.esrf_on.blank?

        profile.esrf_on.to_time.iso8601
      end

      def transplant_operations
        Transplants::RecipientOperation.for_patient(id).order(performed_on: :asc)
      end

      private

      def comorbidity_date_time_from_year(year)
        Time.new(year).iso8601 if year.present?
      end

      def comorbidity_attributes
        profile.document&.comorbidities&.attributes || {}
      end

      def comorbidities
        @comorbidities ||= profile.document&.comorbidities
      end

      def clinical_patient
        @clinical_patient ||= Renalware::Clinical.cast_patient(__getobj__)
      end

      def clinics_patient
        @clinics_patient ||= Renalware::Clinics.cast_patient(__getobj__)
      end

      def letters_patient
        @letters_patient ||= Renalware::Letters.cast_patient(__getobj__)
      end

      def pathology_patient
        @pathology_patient ||= Renalware::Pathology.cast_patient(__getobj__)
      end

      def renal_patient
        @renal_patient ||= Renalware::Renal.cast_patient(__getobj__)
      end

      def transplant_patient
        @transplant_patient ||= Renalware::Transplants::PatientPresenter.new(__getobj__)
      end

      def hd_patient
        @hd_patient ||= Renalware::HD::PatientPresenter.new(self)
      end
    end
  end
end
