FactoryBot.define do
  sequence :email do |n|
    "renalware.user-#{n}@nhs.net"
  end

  sequence :username do |n|
    "renalwareuser-#{n}"
  end

  factory :user, class: "Renalware::User" do
    given_name { Faker::Name.first_name }
    family_name { Faker::Name.last_name }
    username
    email
    password { "supersecret" }
    approved { true }
    professional_position { "Health Minister" }
    signature { Faker::Name.name }
    prescriber { true }
    hospital_centre
    last_activity_at { 1.minute.ago }

    transient do
      role { :clinical }
    end

    # If you want a user to have > 1 role then you can specify e.g.
    #   additional_roles: [:prescriber, :hd_prescriber]
    # - see after(:create) callback
    transient do
      additional_roles { nil }
    end

    after(:build) do |user, evaluator|
      if evaluator.role.present?
        role_record = create(:role, evaluator.role)
        user.roles << role_record
      end
      Array(evaluator.additional_roles).each do |role|
        role_record = create(:role, role)
        user.roles << role_record
      end
    end

    trait :previously_signed_in do
      last_sign_in_at { 1.day.ago }
      current_sign_in_at { 1.day.ago }
    end

    trait :access_locked do
      locked_at { Time.current }
      failed_attempts { 20 }
      unlock_token { SecureRandom.uuid }
    end

    trait :consultant do
      consultant { true }
    end

    trait :unapproved do
      approved { false }

      transient do
        role { nil }
      end
    end

    trait :author do
      signature { Faker::Name.name }
    end

    trait :expired do
      last_activity_at { 90.days.ago }
      expired_at { Time.zone.now }
    end

    trait :super_admin do
      transient do
        role { :super_admin }
      end
    end

    trait :admin do
      transient do
        role { :admin }
      end
    end

    trait :clinical do
      given_name { "Aneurin" }
      family_name { "Bevan" }
      signature { "Aneurin Bevan" }

      transient do
        role { :clinical }
      end
    end

    trait :read_only do
      transient do
        role { :read_only }
      end
    end

    trait :system do
      username { Renalware::SystemUser.username }
    end

    trait :with_ldap_enabled do
      transient do
        ldap_groups { [Renalware::LdapAuthenticatable::RENALWARE_GROUP] }
      end

      before(:create) do |user, evaluator|
        fake_adapter = Class.new do
          def initialize(groups)
            @groups = groups
          end

          def user_in_group?(_username, group_dn)
            @groups.include?(group_dn)
          end

          def valid_credentials?(_username, _password)
            true
          end

          def get_ldap_param(_username, _attribute)
            nil
          end
        end.new(evaluator.ldap_groups)

        user.define_singleton_method(:ldap_adapter) { fake_adapter }
      end
    end
  end
end
