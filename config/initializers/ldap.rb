# This ensures the LDAP error handler is included in all controllers.
# Adding the handler to the engine's ApplicationController would miss any controllers
# in the applpication and would also miss the Devise SessionsController which also
# inherits from the engine's ApplicationController.
# Can be removed when applications are merged into the engine.
Rails.application.config.to_prepare do
  ApplicationController.include Renalware::Concerns::LdapErrorHandler
end
