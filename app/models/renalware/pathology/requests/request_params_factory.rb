module Renalware
  module Pathology
    module Requests
      class RequestParamsFactory
        pattr_initialize :params

        def build
          {
            clinic: clinic,
            consultant: consultant,
            telephone: telephone,
            template: template,
            by: params[:by]
          }
        end

        private

        def clinic
          @clinic ||= requested_clinic || default_clinic
        end

        def consultant
          @consultant ||= requested_consultant || default_consultant
        end

        def telephone
          @telephone ||= requested_telephone || default_telephone
        end

        def template
          requested_template || default_template
        end

        def requested_clinic
          return if params[:clinic_id].blank?

          Renalware::Clinics::Clinic.find(params[:clinic_id])
        end

        def default_clinic
          Renalware::Clinics::Clinic.ordered.first
        end

        def requested_consultant
          return if params[:consultant_id].blank?

          Renalware::Clinics::Consultant.find(params[:consultant_id])
        end

        def default_consultant
          Renalware::Clinics::Consultant.ordered.first
        end

        def requested_telephone
          params[:telephone]
        end

        def default_telephone
          consultant&.telephone
        end

        def requested_template
          params[:template]
        end

        def default_template
          "crs"
        end
      end
    end
  end
end
