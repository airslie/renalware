require "collection_presenter"

module Renalware
  module Renal
    class RegistryPreflightChecksController < BaseController
      include Pagy::Backend

      module WithHDUnit
        def hd_unit
          if current_modality.description.name == "HD"
            Renalware::HD.cast_patient(__getobj__)&.hd_profile&.hospital_unit&.unit_code
          end
        end
      end

      class BasePresenter < SimpleDelegator
        def hd_unit; end

        def renal_profile
          Renalware::Renal.cast_patient(__getobj__).profile
        end
      end

      class PatientsPresenter < BasePresenter
        include WithHDUnit

        def missing_data
          Registry::PreflightChecks::PatientsQuery.missing_data_for(__getobj__)
        end
      end

      class DeathsPresenter < BasePresenter
        def missing_data
          Registry::PreflightChecks::DeathsQuery.missing_data_for(__getobj__)
        end
      end

      class MissingESRFPresenter < BasePresenter
        include WithHDUnit

        def missing_data
          Registry::PreflightChecks::MissingESRFQuery.missing_data_for(__getobj__)
        end
      end

      def patients
        authorize_action
        query = build_query(query_params)
        pagy, patients = patients_for(query)
        render locals: {
          patients: patients,
          query: query.search,
          pagy: pagy
        }
      end

      def deaths
        authorize_action
        query = build_query(query_params)
        pagy, patients = patients_for(query)
        render locals: {
          patients: patients,
          query: query.search,
          pagy: pagy
        }
      end

      def missing_esrf
        authorize_action
        query = build_query(params.fetch(:q, {}))
        pagy, patients = patients_for(query)
        render locals: {
          patients: patients,
          query: query.search,
          pagy: pagy
        }
      end

      private

      def build_query(query_params)
        query_class = Registry::PreflightChecks.const_get("#{action_name.to_s.camelize}Query")
        query_class.new(query_params: query_params)
      end

      def patients_for(query)
        presenter_class = self.class.const_get("#{action_name.to_s.camelize}Presenter")
        pagy, patients = pagy(query.call)
        [pagy, CollectionPresenter.new(patients, presenter_class)]
      end

      def authorize_action
        authorize %i(renalware renal registry_preflight_check), :"#{action_name}?"
      end

      def query_params
        qparams = params.fetch(:q, {})
        qparams[:profile_esrf_on_gteq] ||= 3.years.ago
        qparams
      end
    end
  end
end
