FactoryBot.define do
  factory :letter, class: "Renalware::Letters::Letter" do
    accountable

    # We shouldn't have to do this but for some reason in RSpec tests if the second
    # test in a suite creates a letter it can end up with type of nil - something i
    # n Rails is not setting it. Hence this unpleasant hack:
    type { instance.class.sti_name }

    created_at { Time.zone.today }
    topic factory: :letter_topic

    body { "I am pleased to report a marked improvement in her condition." }

    letterhead factory: %i(letter_letterhead)

    author { accountable_actor }

    factory :draft_letter, class: "Renalware::Letters::Letter::Draft"
    factory :pending_review_letter, class: "Renalware::Letters::Letter::PendingReview"
    factory :approved_letter, class: "Renalware::Letters::Letter::Approved"
    factory :completed_letter, class: "Renalware::Letters::Letter::Completed"
  end
end
