module Renalware
  # Responsible for determining if a user has access to a model based on a
  # configuration file.
  #
  # Example
  #
  # Based on the following configuration file in YAML format (e.g. config/permissions.yml):
  #
  #     super_admin:
  #       User
  #       Patient
  #     admin:
  #       Admission
  #       DrugType
  #
  # We can determine who has access to what models:
  #
  #    configuration = PolicyConfiguration.new(Patient)
  #    configuration.has_privilege?(user) # => true
  #
  #    configuration.has_privilege?(admin_user) # => false
  #
  # We can also determine if a model is restricted?
  #
  #    configuration = PolicyConfiguration.new(Patient)
  #    configuration.restricted? # => true
  #
  #    configuration = PolicyConfiguration.new(Drug)
  #    configuration.restricted? # => false
  #
  class YAMLPermissionConfiguration
    def initialize(model_class, filename = nil)
      @model_class = model_class
      @filename =  filename || default_filename
    end

    attr_reader :model_class, :filename

    def restricted?
      restricted_model_classes.include?(model_class.name)
    end

    def has_permission?(user)
      model_class.name.in? models_user_can_access(user)
    end

    private

    def models_user_can_access(user)
      user.role_names.flat_map { |role| config[role.to_sym] }.compact
    end

    def restricted_model_classes
      config.flat_map { |_, model_names| model_names }
    end

    def config
      @config ||= YAML.load_file(filename).symbolize_keys
    end

    def default_filename
      Renalware::Engine.root.join("config", "permissions.yml")
    end
  end
end
