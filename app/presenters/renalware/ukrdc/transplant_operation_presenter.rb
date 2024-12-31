module Renalware
  module UKRDC
    class TransplantOperationPresenter
      SNOMED_KIDNEY = { code: "70536003​", name: "Kidney Transplant" }.freeze
      SNOMED_PANCREAS = { code: "62438007​", name: "Pancreas Transplant" }.freeze
      SNOMED_KIDNEY_PANCREAS = { code: "6471000179103​", name: "Kidney Transplant" }.freeze

      PROCEDURE_SNOMED_MAP = {
        kidney: SNOMED_KIDNEY,
        kidney_dual: SNOMED_KIDNEY,
        kidney_pancreas: SNOMED_KIDNEY_PANCREAS,
        pancreas: SNOMED_PANCREAS,
        kidney_liver: SNOMED_KIDNEY,
        kidney_other: SNOMED_KIDNEY,
        liver: SNOMED_KIDNEY
      }.freeze

      TRA76_TYPE_LIVE_RELATED_MAP = {
        sibling: { code: 21, description: "Transplant; Live related - sibling" },
        father: { code: 74, description: "Transplant;  Live related - father" },
        mother: { code: 75, description: "Transplant; Live related - mother" },
        child: { code: 77, description: "Transplant; Live related - child " },
        other: { code: 23, description: "Transplant; Live related - other" }
      }.freeze

      TRA76_TYPE_OTHER_MAP = {
        cadaver: { code: 20, description: "Transplant; Cadaver donor" },
        live_unrelated: { code: 24, description: "Transplant; Live genetically unrelated" },
        non_heart_beating: { code: 28, description: "Transplant; non-heart-beating donor" },
        unknown: { code: 29, description: "Transplant; type unknown" }
      }.freeze

      NHSBT_TYPE_MAP = {
        cadaver: "DBD",
        live_unrelated: "LIVE",
        live_related: "LIVE",
        non_heart_beating: "DCD"
      }.freeze

      pattr_initialize :operation
      delegate_missing_to :operation
      delegate :document, to: :operation
      delegate :code, :name, to: :hospital_centre, prefix: true, allow_nil: true

      def procedure_type_snomed_code
        PROCEDURE_SNOMED_MAP.fetch(operation_type.to_sym)[:code]
      end

      def procedure_type_name
        PROCEDURE_SNOMED_MAP.fetch(operation_type.to_sym)[:name]
      end

      def nhsbt_type
        NHSBT_TYPE_MAP[document.donor.type&.to_sym]
      end

      def performed_at
        performed_on && Time.zone.parse(performed_on.to_s)
      end

      # TRA76 is the type of donor. For us it is a combination of donor type and donor relationship
      # (if live related).
      # Unhandled options:
      # 25 "Transplant; Cadaver donor + transp other organ"
      # 26 "Transplant; Live donor + transplant other organ"
      # 27 "Transplant; Live donor non-UK transplant"
      def rr_tra76_options
        @rr_tra76_options ||= begin
          return if document.donor.type.blank?

          donor_type = document.donor.type.to_sym
          if donor_type == :live_related
            rr_tra76_live_related
          else
            rr_tra76_other(donor_type)
          end
        end
      end

      private

      def rr_tra76_live_related
        donor_relationship = document.donor.relationship&.to_sym
        TRA76_TYPE_LIVE_RELATED_MAP[donor_relationship] || TRA76_TYPE_LIVE_RELATED_MAP[:other]
      end

      def rr_tra76_other(donor_type)
        TRA76_TYPE_OTHER_MAP[donor_type] || TRA76_TYPE_OTHER_MAP[:unknown]
      end
    end
  end
end
