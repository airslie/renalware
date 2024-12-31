module Renalware
  Rails.benchmark "Adding User Groups" do
    user_ids = User.pluck(:id).sample(6).uniq
    p user_ids
    Users::Group.create!(
      name: "Transplant Coordinators",
      user_ids: user_ids,
      letter_electronic_ccs: true,
      by: User.first
    )
  end
end
