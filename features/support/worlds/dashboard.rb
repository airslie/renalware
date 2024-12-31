module World
  module Dashboard
    module Domain
      def expect_draft_letter_accessible_from_dashboard(user:, patient:)
        letter_patient = Renalware::Letters.cast_patient(patient)
        dashboard = Renalware::Dashboard::DashboardPresenter.new(user)

        expect(dashboard.letters_in_progress.first).to eq(letter_patient.letters.draft.first)
      end

      def expect_pending_letter_accessible_from_dashboard(user:, patient:)
        letter_patient = Renalware::Letters.cast_patient(patient)
        dashboard = Renalware::Dashboard::DashboardPresenter.new(user)

        expect(dashboard.letters_in_progress.first).to(
          eq(letter_patient.letters.pending_review.first)
        )
      end

      def expect_patient_accessible_from_dashboard(user:, patient:)
        dashboard = Renalware::Dashboard::DashboardPresenter.new(user)

        patient_names = dashboard.bookmarks.map { |bookmark| bookmark.patient.given_name }
        expect(patient_names.first).to eq(patient.given_name)
      end
    end

    module Web
      def expect_draft_letter_accessible_from_dashboard(user:, patient:)
        login_as user

        visit dashboard_path

        within("#letters-in-progress") do
          expect(page).to have_content(patient.to_s)
        end
      end

      def expect_pending_letter_accessible_from_dashboard(user:, patient:)
        login_as user

        visit dashboard_path

        within("#letters-in-progress") do
          expect(page).to have_content(patient.to_s)
        end
      end

      def expect_patient_accessible_from_dashboard(user:, patient:)
        login_as user

        visit dashboard_path

        within("#bookmarks") do
          expect(page).to have_content(patient.to_s)
        end
      end
    end
  end
end
