module World
  module Letters::Contact
    module Domain
      # @section seeding
      #
      def seed_contact(patient:, person:)
        patient = letters_patient(patient)
        description = find_contact_description(system_code: "referring_physician")
        contact = patient.assign_contact(person: person, description: description)
        contact.save!
      end

      # @section commands
      #
      def assign_contact(patient:, person:, description_name: "Sibling", default_cc: false, **_)
        patient = letters_patient(patient)
        description_attrs = determine_description_attrs(description_name)
        contact_attrs = { person: person, default_cc: default_cc }.merge(description_attrs)
        contact = patient.assign_contact(contact_attrs)
        contact.save!
      end

      def assign_new_person_as_contact(patient:,
                                       person_attrs:,
                                       user:, description_name: "Sibling",
                                       **_)
        patient = letters_patient(patient)
        person_attrs = {
          given_name: person_attrs[:given_name],
          family_name: person_attrs[:family_name],
          address_attributes: { street_1: "1 Main St" },
          by: user
        }
        description_attrs = determine_description_attrs(description_name)
        contact_attrs = { person_attributes: person_attrs }.merge(description_attrs)
        contact = patient.assign_contact(contact_attrs)
        contact.save!
      end

      # @section expectations
      #
      def expect_available_contact(patient:, person:, description_name: "Sibling")
        patient = letters_patient(patient)
        expect(patient).to have_available_contact(person)

        description = find_contact_description(name: description_name)
        patient.with_contact_for(person) do |contact|
          expect(contact).to be_described_as(description || description_name)
        end
      end

      def expect_default_ccs(patient:, person:)
        patient = letters_patient(patient)
        expect(patient).to have_default_cc(person)
      end

      # @section helpers
      #
      def find_contact_description(attrs)
        Renalware::Letters::ContactDescription.find_by(attrs)
      end

      def find_unspecified_contact_description
        Renalware::Letters::ContactDescription[:other]
      end

      def determine_description_attrs(description_name)
        contact_description = find_contact_description(name: description_name)

        if contact_description.present?
          { description: contact_description }
        else
          { description: find_unspecified_contact_description, other_description: description_name }
        end
      end
    end

    module Web
      include Domain

      # @section commands
      #
      def assign_contact(patient:, person:, user:, default_cc: false, description_name: "Sibling")
        login_as user

        visit patient_letters_contacts_path(patient)
        click_on t("btn.add")
        wait_for_ajax

        within("#add-patient-contact-modal") do
          select2(
            person.family_name,
            css: "#person-id-select2",
            search: true
          )

          find(:css, "#letters_contact_default_cc").set(true) if default_cc

          if find_contact_description(name: description_name)
            select description_name, from: t_contact(:description)
          else
            select t_contact_description_unspecified, from: t_contact(:description)
            fill_in t_contact(:other_description), with: description_name
          end

          submit_form
        end

        wait_for_ajax
      end

      def assign_new_person_as_contact(patient:, person_attrs:, user:, description_name:, **_)
        login_as user

        visit patient_letters_contacts_path(patient)
        click_on t("btn.add")

        within("#add-patient-contact-modal") do
          click_on "Person not found in directory"
          wait_for_ajax

          fill_in "Family Name", with: person_attrs[:family_name]
          fill_in "Given Name", with: person_attrs[:given_name]
          fill_in "Line 1", with: "1 Main St"

          if find_contact_description(name: description_name)
            select description_name, from: t_contact(:description)
          else
            select t_contact_description_unspecified, from: t_contact(:description)
            fill_in t_contact(:other_description), with: description_name
          end

          submit_form
        end

        wait_for_ajax
      end

      # @section helpers
      #
      def t_contact(key)
        Renalware::Letters::Contact.human_attribute_name(key)
      end

      def t_contact_description_unspecified
        t("renalware.letters.contacts.form.description.other")
      end
    end
  end
end
