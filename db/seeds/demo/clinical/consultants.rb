module Renalware
  Rails.benchmark "Assign the consultant flag to a sample of users" do
    user_ids = User.pluck(:id)
    5.times do
      User.find(user_ids.sample).update_column(:consultant, true)
    end
  end
end
