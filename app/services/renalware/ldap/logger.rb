module Renalware
  module Ldap
    class Logger
      class << self
        def debug(message)
          Rails.logger.debug(add_prefix(message)) if log?
        end

        def info(message)
          Rails.logger.info(add_prefix(message)) if log?
        end

        def error(message)
          Rails.logger.error(add_prefix(message)) if log?
        end

        private

        def add_prefix(message)
          " \e[36mLDAP:\e[0m #{message}"
        end

        def log?
          Renalware.config.ldap_logger
        end
      end
    end
  end
end
