# lib/renalware/config_accessors.rb
module Renalware
  # Provides a lightweight replacement for ActiveSupport::Configurable,
  # which is deprecated in Rails 8.2.
  #
  # Including this module in a Configuration class gives you:
  #
  #   - `config_accessor` for defining configuration attributes
  #     with optional lazy default blocks
  #   - Per-class isolation of defaults (no cross-talk between
  #     different configuration classes)
  #   - Memoized defaults by default, matching the historical
  #     behaviour of ActiveSupport::Configurable
  #   - `.config` and `.configure` class methods for a familiar
  #     Rails-style configuration API:
  #
  #         MyDomain.configure do |c|
  #           c.some_setting = 123
  #         end
  #
  #         MyDomain.config.some_setting
  #
  # Default blocks are evaluated in the instance context via
  # `instance_exec`, allowing defaults to depend on other
  # configuration values. Defaults are memoized on first access
  # unless `memoize: false` is specified.
  #
  # This module is intended for engine or domain-level configuration
  # objects (eg HD::Configuration, PD::Configuration) where a small,
  # dependency-free, Rails-like configuration DSL is desirable.
  # A mixin to provide config accessors with defaults and memoization.
  #
  # Example usage:
  #   class MyConfig
  #     include Renalware::ConfigAccessors
  #
  #     config_accessor :bar do
  #       compute_default_bar_value
  #     end
  #     config_accessor :foo, memoize: true { expensive_computation }
  #     config_accessor :bar, memoize: false { reevaluate me every time }
  #   end
  #
  module ConfigAccessors
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # ---- DSL for accessors ----

      def config_defaults
        @config_defaults ||= {}
      end

      # config_accessor :foo, memoize: true { ... }
      def config_accessor(name, memoize: true, &default) # rubocop:disable Metrics/MethodLength
        config_defaults[name] = {
          default: default,
          memoize: memoize
        }

        define_method(name) do
          ivar = :"@#{name}"

          if memoize && instance_variable_defined?(ivar)
            return instance_variable_get(ivar)
          end

          spec = self.class.config_defaults[name]
          value =
            if spec[:default]
              instance_exec(&spec[:default])
            end

          instance_variable_set(ivar, value) if memoize
          value
        end

        define_method("#{name}=") do |value|
          instance_variable_set(:"@#{name}", value)
        end
      end

      # ---- Rails-style config singleton ----

      def config
        @config ||= new
      end

      def configure
        yield config
      end
    end
  end
end
