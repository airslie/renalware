# require_relative "configuration"

module Renalware
  module Authoring
    def self.table_name_prefix = "snippets_"
    def self.cast_user(user) = user.becomes(Authoring::User)

    class Engine < Rails::Engine
      isolate_namespace Authoring
    end
  end
end
