module World
  module PD::ExitSiteInfection
    module Domain
      # @section helpers
      #
      def infection_for(patient)
        patient.exit_site_infections.last!
      end

      # @section commands
      #
      def record_exit_site_infection_for(patient:,
                                         user:,
                                         diagnosed_on:,
                                         **)
        patient.exit_site_infections.create(
          diagnosis_date: diagnosed_on,
          **
        )
      end

      def revise_exit_site_infection_for(patient:, user:, diagnosed_on:, clinical_presentation: nil)
        infection = patient.exit_site_infections.last!

        infection.diagnosis_date = diagnosed_on
        if clinical_presentation.present?
          infection.clinical_presentation = clinical_presentation
        end
        infection.save!
      end

      def exit_site_infection_drug_selector
        nil
      end

      # @section expectations
      #
      def expect_exit_site_infection_to_recorded(patient:)
        exit_site_infection = patient.exit_site_infections.last
        organism = exit_site_infection.infection_organisms.last

        expect(exit_site_infection).to be_present
        expect(organism).to be_present
      end

      def expect_exit_site_infections_revisions_recorded(patient:)
        exit_site_infection = patient.exit_site_infections.last!
        organism = exit_site_infection.infection_organisms.last!

        expect(exit_site_infection.created_at).not_to eq(exit_site_infection.updated_at)
        expect(organism.created_at).not_to eq(organism.updated_at)
      end
    end

    module Web
      include Domain

      # @section commands
      #
      def record_exit_site_infection_for(patient:,
                                         user:,
                                         diagnosed_on:,
                                         outcome:,
                                         clinical_presentation:,
                                         **_args)
        login_as user

        visit new_patient_pd_exit_site_infection_path(patient)
        fill_in "Diagnosed on", with: diagnosed_on
        fill_in "Outcome", with: outcome

        clinical_presentation&.each do |item|
          label = t(item,
                    scope: "enumerize.renalware/pd/exit_site_infection.clinical_presentation")
          check label
        end

        submit_form
      end

      def revise_exit_site_infection_for(patient:, user:, diagnosed_on:)
        login_as user

        visit patient_pd_exit_site_infection_path(patient, infection_for(patient))
        within "#infection" do
          click_on t("btn.edit")
          fill_in "Diagnosed on", with: diagnosed_on
          click_on t("btn.save")
          wait_for_ajax
        end
      end

      def exit_site_infection_drug_selector
        ->(drug_name) { select(drug_name, from: "Drug") }
      end
    end
  end
end
