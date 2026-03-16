class Renalware::Devise::RegistrationsController < Devise::RegistrationsController
  helper Renalware::ApplicationHelper
  include Renalware::Concerns::DeviseControllerMethods

  def new
    return super if Renalware.config.database_authentication_enabled?

    raise ActionController::RoutingError, "User registration is not available."
  end

  def create
    return super if Renalware.config.database_authentication_enabled?

    raise ActionController::RoutingError, "User registration is not available."
  end
end
