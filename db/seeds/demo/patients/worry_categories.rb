module Renalware
  user = User.first
  (1..10).each do |idx|
    Patients::WorryCategory.create!(name: "Category#{idx}", by: user)
  end
end
