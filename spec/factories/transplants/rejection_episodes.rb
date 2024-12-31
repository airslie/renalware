FactoryBot.define do
  factory :transplant_rejection_episode, class: "Renalware::Transplants::RejectionEpisode" do
    accountable
    recorded_on { "2019-01-01" }
    notes { "xyz" }
  end
end
