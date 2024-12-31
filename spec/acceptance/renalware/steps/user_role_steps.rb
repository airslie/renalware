module Renalware::UserRoleSteps
  attr_reader :user

  step :create_clinician, ":name is a clinician"

  def create_clinician(name)
    @user = FactoryBot.create(:user, :clinical, given_name: name)
  end
end
