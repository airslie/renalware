module Renalware
  # Responsible for determining if a user can manage the provided record. It
  # provides the Base policy for Renalware.
  #
  # It collaborates with a permission configuration object to determine
  # if the record is is an instance of a model that is #restricted? and
  # if the user #has_permission? to manage the record.
  #
  class BasePolicy < ApplicationPolicy
    def initialize(user, record, permission_configuration = nil)
      super(user, record)
      @permission_configuration = permission_configuration || default_permission_configuration
    end

    def index?
      return true if user_is_devops? || user_is_super_admin?
      return permission_for_restricted? if restricted?

      has_any_role?
    end

    def show?
      has_any_role?
    end

    def create?
      return true if user_is_devops? || user_is_super_admin?
      return permission_for_restricted? if restricted?

      write_privileges?
    end

    def update?
      create?
    end

    def destroy?
      create?
    end

    def sort?
      update?
    end

    alias move? sort?

    def contact_added?
      update?
    end

    def debug?
      user_is_super_admin?
    end

    protected

    # For each role define e.g. user_is_admin?
    Role::ROLES.each do |role|
      define_method :"user_is_#{role}?" do
        user.has_role?(role)
      end
    end

    def user_is_any_admin?
      user_is_super_admin? || user_is_admin? || user_is_devops?
    end

    def user_is_at_least_super_admin?
      user_is_super_admin? || user_is_devops?
    end

    private

    attr_reader :permission_configuration

    def restricted?
      permission_configuration.restricted?
    end

    def permission_for_restricted?
      permission_configuration.has_permission?(user)
    end

    def write_privileges?
      user_is_super_admin? || user_is_admin? || user_is_clinical?
    end

    def has_any_role?
      user.roles.any?
    end

    def default_permission_configuration
      YAMLPermissionConfiguration.new(record.class)
    end
  end
end
