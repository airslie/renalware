# frozen_string_literal: true

module World
  module Directory::Person
    module Domain
      # @section helpers
      #
      def fetch_person
        Renalware::Directory::Person.first_or_initialize
      end

      def valid_person_attributes
        FactoryBot.attributes_for(
          :directory_person,
          address_attributes: FactoryBot.attributes_for(:address)
        )
      end

      # @section seeding
      #
      def seed_person(user:, given_name: Faker::Name.first_name)
        Renalware::Directory::Person.create!(
          valid_person_attributes.merge(given_name: given_name, by: user)
        )
      end

      # @section commands
      #
      def create_person(user:, attributes: {})
        Renalware::Directory::Person.create(
          valid_person_attributes
            .merge(by: user)
            .merge(attributes)
        )
      end

      def update_person(user:)
        travel_to 1.hour.from_now

        person = fetch_person
        person.update!(
          title: "Monsieur",
          updated_at: Time.zone.now,
          by: user
        )
      end

      # @section expectations
      #
      def expect_person_to_exist
        person = Renalware::Directory::Person.first
        expect(person).to be_present
        expect(person.address).to be_present
      end

      def expect_person_to_be_refused
        expect(Renalware::Directory::Person.count).to eq(0)
      end
    end

    module Web
      include Domain

      def create_person(user:, attributes: {})
        login_as user
        visit directory.new_person_path

        attr = valid_person_attributes.merge(attributes)

        fill_in t_person(:given_name), with: attr[:given_name]
        fill_in t_person(:family_name), with: attr[:family_name]
        fill_in t_person(:title), with: attr[:title]

        # removed fill_in t_address(:name), with: attr[:address_attributes][:name]
        fill_in t_address(:street_1), with: attr[:address_attributes][:street_1]
        fill_in t_address(:town), with: attr[:address_attributes][:town]

        click_on t("btn.create")
      end

      def update_person(user:)
        login_as user
        visit directory.people_path
        click_on t("btn.edit")

        fill_in t_person(:title), with: "Monsieur"

        submit_form
      end

      def t_person(key)
        t(key, scope: "activerecord.attributes.renalware/directory/person")
      end

      def t_address(key)
        t(key, scope: "activerecord.attributes.renalware/address")
      end
    end
  end
end
