# frozen_string_literal: true

require "capybara_select2/selectors"

module World
  module PD::PeritonitisEpisode
    module Domain
      # @section helpers
      #
      def episode_for(patient)
        patient.peritonitis_episodes.last!
      end

      # @section commands
      #
      def record_peritonitis_episode_for(patient:, user:, diagnosed_on:)
        patient.peritonitis_episodes.create!(
          diagnosis_date: diagnosed_on
        )
      end

      def revise_peritonitis_episode_for(patient:, user:, diagnosed_on:)
        episode = patient.peritonitis_episodes.last!

        episode.update!(diagnosis_date: diagnosed_on)
      end

      def peritonitis_episode_drug_selector; end

      # @section expectations
      #
      def expect_peritonitis_episode_to_be_recorded(patient:)
        episode = episode_for(patient)
        organism = episode.infection_organisms.last
        prescription = episode.prescriptions.last

        expect(episode).to be_present
        expect(organism).to be_present
        expect(prescription).to be_present
      end

      def expect_peritonitis_episodes_revisions_recorded(patient:)
        exit_site_infection = patient.peritonitis_episodes.last!
        organism = exit_site_infection.infection_organisms.last!

        expect(exit_site_infection.created_at).not_to eq(exit_site_infection.updated_at)
        expect(organism.created_at).not_to eq(organism.updated_at)

        expect_exit_site_prescriptions_to_be_revised(patient, exit_site_infection)
      end
    end

    module Web
      include Domain

      # @section commands
      #
      def record_peritonitis_episode_for(patient:, user:, diagnosed_on:)
        login_as user

        visit new_patient_pd_peritonitis_episode_path(patient)
        select2(
          "Recurrent",
          css: "#peritonitis_episode_types"
        )

        fill_in "Diagnosed on", with: diagnosed_on

        click_on "Save"
      end

      def revise_peritonitis_episode_for(patient:, user:, diagnosed_on:)
        login_as user

        episode = episode_for(patient)
        visit patient_pd_peritonitis_episode_path(patient, episode)

        within "#" + dom_id(episode) do
          click_on "Edit"

          expect(page).to have_css(".select2-container")
          select2("Relapsing", css: "#peritonitis_episode_types")
          fill_in "Diagnosed on", with: diagnosed_on
          click_on "Save"
          wait_for_ajax
        end
      end

      def peritonitis_episode_drug_selector
        lambda do |drug_name|
          find("select#medications_prescription_drug_id optgroup[label='Peritonitis']")
            .find(:option, text: drug_name).select_option
        end
      end
    end
  end
end
