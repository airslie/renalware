require_relative "access_steps"

module Renalware
  module Accesses
    module AccessProfileSteps
      include Accesses::AccessSteps
      extend WebSteps

      step :create_profile, ":user records an access profile for :patient"
      step :create_profile, ":patient has a recorded access profile"
      step :create_bad_profile, ":user submits an erroneous access profile"
      step :assert_profile_exists, ":patient has a new access profile"
      step :update_access_profile, ":user can update the access profile for :patient"
      step :assert_access_profile_is_refused, "the access profile is not accepted"

      def create_profile(*, side: :left)
        attrs = FactoryBot.attributes_for(
          :access_profile,
          type: FactoryBot.create(:access_type),
          side: side,
          formed_on: Time.zone.today,
          started_on: Time.zone.today,
          by: user
        )
        accesses_patient.profiles.create(attrs)
      end

      def assert_profile_exists(*)
        expect(accesses_patient.profiles.reload.count).to be > 0
      end

      def create_bad_profile(*)
        create_profile(side: nil)
      end

      def update_access_profile(*)
        profile = accesses_patient.profiles.first_or_initialize
        profile.update(
          updated_at: 1.hour.from_now,
          started_on: 1.hour.from_now,
          by: user
        )
      end

      def assert_access_profile_is_refused(*)
        expect(Renalware::Accesses::Profile.count).to eq(0)
      end

      web_steps do
        def create_profile(*, side: :left)
          access_type = FactoryBot.create(:access_type)
          login_as_clinical

          po = Pages::Accesses::ProfilePage.new(accesses_patient)
          po.visit_add
          po.access_type = access_type.to_s
          po.side = side.to_s.capitalize
          po.formed_on = l(Time.zone.today)
          po.save
        end

        def update_access_profile(*, side: :left)
          login_as user
          po = Pages::Accesses::ProfilePage.new(accesses_patient)
          po.visit_edit
          po.side = side.to_s.capitalize
          po.save
        end
      end
    end
  end
end
