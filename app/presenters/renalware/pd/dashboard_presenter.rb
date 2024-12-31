module Renalware
  module PD
    class DashboardPresenter
      include PresenterHelper
      include Renalware::Concerns::Pageable

      attr_accessor :patient

      def initialize(patient)
        @patient = patient
      end

      def current_regime
        patient.pd_regimes.any? && patient.pd_regimes.current
      end

      def capd_regimes
        @capd_regimes ||= CAPDRegime.for_patient(patient).with_bags.ordered.page(1).per(5)
      end

      def apd_regimes
        @apd_regimes ||= APDRegime.for_patient(patient).with_bags.ordered.page(1).per(5)
      end

      def peritonitis_episodes
        @peritonitis_episodes ||= begin
          episodes = PeritonitisEpisode
            .for_patient(patient)
            .ordered
            .includes(:episode_types, infection_organisms: :organism_code)
          present(episodes, PeritonitisEpisodePresenter)
        end
      end

      def exit_site_infections
        @exit_site_infections ||= begin
          ExitSiteInfection
            .for_patient(patient)
            .includes(infection_organisms: :organism_code)
            .ordered
        end
      end

      def pet_adequacies
        @pet_adequacies ||= PETAdequacyResult.for_patient(patient).ordered
      end

      def assessments
        @assessments ||= Assessment.for_patient(patient).ordered
      end

      def training_sessions
        @training_sessions ||= TrainingSession.for_patient(patient).ordered
      end

      def latest_pd_line_change_events
        @latest_pd_line_change_events ||= Events::LineChangeEventQuery.new(patient).call(limit: 1)
      end
    end
  end
end
