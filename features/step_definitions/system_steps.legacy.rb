Given(/^that I'm logged in$/) do
  @user ||= FactoryBot.create(:user, :super_admin)
  login_as @user
end
