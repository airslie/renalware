FactoryBot.define do
  factory :user_feedback, class: "Renalware::System::UserFeedback" do
    author factory: %i(user)
    comment { "My feedback is.." }
    admin_notes { "" }
    category { :general_comment }
  end
end
