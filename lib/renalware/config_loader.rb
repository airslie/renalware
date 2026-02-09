module Renalware
  module ConfigLoader
    # This serves the same purpose as Rails.application.config_for but for the
    # renalware engine. It allows us to load config files from the engine's
    # config directory.
    def self.config_for(name, env: Rails.env)
      yaml_path = Rails.root.join("config", "#{name}.yml")
      config = YAML.safe_load File.open(yaml_path)
      env_config = config["default"].merge(config[env.to_s] || {})
      env_config.deep_symbolize_keys
    end
  end
end
