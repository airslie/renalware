module World
  module Directory::Person
    module Domain
      # @section helpers
      #
      def fetch_person
        Renalware::Directory::Person.first_or_initialize
      end

      def valid_person_attributes
        FactoryGirl.attributes_for(:directory_person,
          address_attributes: FactoryGirl.attributes_for(:address)
        )
      end

      # @section seeding
      #
      def seed_person(given_name: Faker::Name.first_name, user:)
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
        person.update_attributes!(
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
        visit new_directory_person_path

        attr = valid_person_attributes.merge(attributes)

        fill_in t_person(:given_name), with: attr[:given_name]
        fill_in t_person(:family_name), with: attr[:family_name]
        fill_in t_person(:title), with: attr[:title]

        fill_in t_address(:name), with: attr[:address_attributes][:name]
        fill_in t_address(:street_1), with: attr[:address_attributes][:street_1]
        fill_in t_address(:city), with: attr[:address_attributes][:city]

        click_on "Create"
      end

      def update_person(user:)
        login_as user
        visit directory_people_path
        click_on "Edit"

        fill_in t_person(:title), with: "Monsieur"

        click_on "Save"
      end

      def t_person(key)
        I18n.t(key, scope: "activerecord.attributes.renalware/directory/person")
      end

      def t_address(key)
        I18n.t(key, scope: "activerecord.attributes.renalware/address")
      end
    end
  end
end
