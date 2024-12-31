FactoryBot.define do
  factory :transplant_registration_status, class: "Renalware::Transplants::RegistrationStatus" do
    accountable
    # rubocop:disable FactoryBot/FactoryAssociationWithStrategy
    # NB using the recommendation here:
    #   description { association(:transplant_registration_status_description) }
    # fails in a spec where we use attributes_for(:transplant_registration_status).
    # Not sure why yet so disabling the rubocop here for now.
    description { create(:transplant_registration_status_description) }
    # rubocop:enable FactoryBot/FactoryAssociationWithStrategy

    started_on { Time.zone.today }
  end
end
