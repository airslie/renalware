class Renalware::Devise::RegistrationsController < Devise::RegistrationsController
  helper Renalware::ApplicationHelper
  include Renalware::Concerns::DeviseControllerMethods

  def new
    if Renalware.config.ldap_authentication
      raise ActionController::RoutingError, "User registration is not available."
    else
      super
    end
  end

  def create
    if Renalware.config.ldap_authentication
      raise ActionController::RoutingError, "User registration is not available."
    else
      super
    end
  end
end
