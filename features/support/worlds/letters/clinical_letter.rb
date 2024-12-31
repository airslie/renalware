module World
  module Letters::ClinicalLetter
    module Domain
      def build_clinical_letter_attributes(patient, created_at, user)
        valid_simple_letter_attributes(patient).merge(
          clinical: true,
          created_at: created_at,
          author: user,
          by: user
        )
      end

      def seed_clinical_letter_for(patient, user:)
        patient = letters_patient(patient)

        letter_attributes = build_clinical_letter_attributes(patient, Time.zone.today, user)

        seed_letter(patient, letter_attributes)
      end

      # @section commands
      #
      def draft_clinical_letter(patient:, user:, created_at:)
        patient = letters_patient(patient)

        letter_attributes = build_clinical_letter_attributes(patient, created_at, user)

        draft_letter(patient, letter_attributes)
      end

      def clinical_letter_for(patient)
        Renalware::Letters.cast_patient(patient).letters.first
      end

      def expect_clinical_letter_to_exist(patient:)
        expect(clinical_letter_for(patient)).to_not be_nil
      end

      def expect_clinical_letter_to_list_current_prescriptions(patient:)
        letter = clinical_letter_for(patient)

        letter = Renalware::Letters::LetterPresenterFactory.new(letter)
        expect(letter.letter_event.part_classes).to include Renalware::Letters::Part::Prescriptions
      end

      def expect_clinical_letter_to_list_problems(patient:)
        letter = clinical_letter_for(patient)

        letter = Renalware::Letters::LetterPresenterFactory.new(letter)
        expect(letter.letter_event.part_classes).to include Renalware::Letters::Part::Problems
      end

      def expect_clinical_letter_to_list_recent_pathology_results(patient:)
        letter = clinical_letter_for(patient)

        letter = Renalware::Letters::LetterPresenterFactory.new(letter)
        expect(letter.letter_event.part_classes)
          .to include Renalware::Letters::Part::RecentPathologyResults
      end

      def expect_clinical_letter_to_list_allergies(patient:)
        letter = clinical_letter_for(patient)

        letter = Renalware::Letters::LetterPresenterFactory.new(letter)
        expect(letter.letter_event.part_classes).to include Renalware::Letters::Part::Allergies
      end
    end

    module Web
      include Domain

      def draft_clinical_letter(patient:, user:, created_at:)
        login_as user
        FactoryBot.create(:letter_topic, text: "Foo bar")
        visit patient_letters_letters_path(patient)
        click_on t("btn.create_")
        click_on "Clinical Letter"

        attributes = valid_simple_letter_attributes(patient)
        select attributes[:letterhead].name, from: "Letterhead"
        slim_select user.to_s, from: "Author"
        slim_select attributes[:description], from: "Topic"

        within ".bottom" do
          click_on t("btn.create")
        end
      end

      def expect_clinical_letter_to_list_current_prescriptions(patient:)
        visit patient_letters_letters_path(patient)
        click_on t("btn.preview")

        visit_iframe_content

        patient.prescriptions.each do |prescription|
          expect(page.body).to include(prescription.drug_name)
        end
      end

      def expect_clinical_letter_to_list_clinical_observations(patient:)
        visit patient_letters_letters_path(patient)
        click_on t("btn.preview")

        visit_iframe_content

        clinic_visit = clinic_visit_for(patient)
        expect(page.body).to include(clinic_visit.height.to_s)
        expect(page.body).to include(clinic_visit.weight.to_s)
        expect(page.body).to include(clinic_visit.bp)
      end

      def expect_clinical_letter_to_list_problems(patient:)
        visit patient_letters_letters_path(patient)
        click_on t("btn.preview")

        visit_iframe_content

        patient.problems.each do |problem|
          expect(page.body).to include(problem.description)
          expect(page.body).to include(problem.notes.first.description)
        end
      end

      def expect_clinical_letter_to_list_recent_pathology_results(patient:)
        visit patient_letters_letters_path(patient)
        click_on t("btn.preview")

        visit_iframe_content

        pathology_patient = Renalware::Pathology.cast_patient(patient)

        expect(pathology_patient.observations).to be_present

        pathology_patient.observations.each do |observation|
          expect(page.body).to include(observation.to_s)
        end
      end

      def expect_clinical_letter_to_list_allergies(patient:)
        visit patient_letters_letters_path(patient)
        click_on t("btn.preview")

        visit_iframe_content

        clinical_patient = Renalware::Clinical.cast_patient(patient)

        expect(clinical_patient.allergies).to be_present

        clinical_patient.allergies.each do |allergy|
          expect(page.body).to include(allergy.description)
        end
      end
    end
  end
end
