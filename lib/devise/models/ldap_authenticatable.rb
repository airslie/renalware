# Shim to make our Renalware::LdapAuthenticatable concern available
# as Devise::Models::LdapAuthenticatable so Devise can find it
module Devise
  module Models
    module LdapAuthenticatable
      extend ActiveSupport::Concern

      included do
        include Renalware::LdapAuthenticatable
      end
    end
  end
end
