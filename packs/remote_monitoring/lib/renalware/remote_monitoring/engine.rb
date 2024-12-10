# frozen_string_literal: true

module Renalware
  module RemoteMonitoring
    def self.table_name_prefix = "remote_monitoring_"

    class Engine < Rails::Engine
      isolate_namespace RemoteMonitoring
    end
  end
end
