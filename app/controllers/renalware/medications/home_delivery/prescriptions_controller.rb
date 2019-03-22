# frozen_string_literal: true

require_dependency "renalware/medications"

module Renalware
  module Medications
    module HomeDelivery
      class PrescriptionsController < BaseController
        include Renalware::Concerns::PdfRenderable
        include PresenterHelper

        def index
          respond_to do |format|
            format.pdf do
              authorize prescriptions
              render_index_pdf prescriptions
            end
          end
        end

        private

        def prescriptions
          @prescriptions ||= begin
            patient
              .prescriptions
              .current
              .where(provider: :home_delivery)
              .includes(:medication_route, :drug)
          end
        end

        def render_index_pdf(prescriptions)
          options = default_pdf_options.merge!(
            pdf: pdf_filename,
            layout: "renalware/layouts/letter",
            locals: {
              patient: patient,
              prescriptions: present(prescriptions, PrescriptionPresenter)
            }
          )
          render options
        end

        def pdf_filename
          "#{patient.local_patient_id} prescriptions-for-home-delivery"
        end
      end
    end
  end
end