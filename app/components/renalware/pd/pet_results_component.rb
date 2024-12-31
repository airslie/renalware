module Renalware
  module PD
    class PETResultsComponent < ApplicationComponent
      include Pagy::Backend
      include Pagy::Frontend
      include ToggleHelper
      include DropdownButtonHelper
      attr_reader :patient, :pagination, :current_user

      TITLE = "PET Results".freeze

      def initialize(patient:, current_user:)
        @patient = PD.cast_patient(patient)
        @current_user = current_user
        super
      end

      def results
        @results ||= begin
          @pagination, @results = pagy(scope, items: 6)
          @results
        end
      end

      def title
        if pagination.limit < pagination.count
          "#{TITLE} (#{pagination.limit} of #{pagination.count})"
        else
          "#{TITLE} (#{pagination.limit})"
        end
      end

      def graph_data
        patient
          .pet_results
          .where("d_pcr is not null and net_uf is not null")
          .order(performed_on: :asc)
          .pluck(:d_pcr, :net_uf)
      end

      # TODO: Finish adding plot bands and fix x-axis. Need to build this graph
      # in codepen outside of the app so we can experiment - at the moment
      # the x axis is built from the data series (pcr), which is not linear.
      # So we need to specify the x axis and the series data separately.
      def graph_options
        {
          xtitle: "D/Pcr",
          ytitle: "net UF",
          curve: false,
          discrete: true, # required to allow points to double back on themselves
          library: {
            xAxis: {
              plotBands: [
                {
                  from: 0.0,
                  to: 0.5,
                  color: "rgba(68, 170, 213, 0.1)",
                  label: {
                    text: "Low",
                    style: {
                      color: "#606060"
                    }
                  }
                }
              ]
            }
          }
        }
      end

      private

      def scope
        patient.pet_results.includes([:overnight_dextrose_concentration]).ordered
      end
    end
  end
end
