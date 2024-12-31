module World
  module Patients
    module Bookmarks
      module Domain
        # @section commands
        #
        #
        def bookmark_patient(options)
          create_bookmark(**options)
        end

        def create_bookmark(user:, patient_name:, notes: "", urgent: false)
          user = Renalware::Patients.cast_user(user)
          patient = find_or_create_patient_by_name(patient_name)
          Renalware::Patients::Bookmark.create!(user: user,
                                                patient: patient,
                                                notes: notes,
                                                urgent: urgent)
        end

        def delete_bookmark(user:, patient_name:)
          patient = find_patient_by_given_name(patient_name)
          user = Renalware::Patients.cast_user(user)

          bookmark = user.bookmarks.find_by(patient: patient)
          bookmark.destroy
        end

        # @section expectations
        #
        def expect_user_to_have_patients_in_bookmarks(user, patients)
          user = Renalware::Patients.cast_user(user)
          expect(user.patients.map(&:given_name)).to eq(patients.map(&:given_name))
        end

        def expect_user_to_have_patient_in_bookmarks(user:,
                                                     patient_name:,
                                                     notes: nil,
                                                     urgent: false)
          user = Renalware::Patients.cast_user(user)
          patient = user.patients.where(given_name: patient_name).first
          expect(patient).to_not be_nil
          bookmark = patient.bookmarks.first
          expect(bookmark).to_not be_nil
          expect(bookmark.notes).to eq(notes)
          expect(bookmark.urgent.to_s).to eq(urgent.to_s)
        end
      end

      module Web
        include Domain

        def bookmark_patient(user:, patient_name:, notes: "", urgent: false)
          login_as user
          visit_patient(patient_name)

          find("a", text: "Bookmark").click

          # Modal shown here
          within("#add-patient-bookmark-modal") do
            check("Urgent") if urgent
            fill_in("Notes", with: notes)
            find("input.button").click
          end
        end

        def delete_bookmark(user:, patient_name:)
          login_as user
          visit_patient(patient_name)
          find("a", text: "Remove bookmark").click
          page.driver.browser.switch_to.alert.accept
        end

        private

        def visit_patient(patient_given_name)
          patient = find_patient_by_given_name(patient_given_name)
          visit patient_path(id: patient)
          patient
        end
      end
    end
  end
end
