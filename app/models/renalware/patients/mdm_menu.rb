module Renalware
  module Patients
    # Queries for and stores in a class variable the list of MDM 'scopes' to use when building
    # the MDM menu. An example of a scope is "transplants" or "low_clearance" and must match a
    # namespace in the code. The title of the MDM link in the MDMs menu is from the title attr
    # if present.
    # If you make changes to the system_view_metadata table to add/edit/remove a scope,
    # you will need to restart the app for changes to to reflect in the menu. It is done this
    # way as a changes are rare and we want to avoid running this query too many times.
    # I think it will run once per process thread
    class MDMMenu
      thread_cattr_accessor :cached_items

      def self.items
        return cached_items if cached_items

        self.cached_items = menu_definitions
        cached_items
      end

      def self.menu_definitions
        Rails.logger.info "#### Loading MDM scope names! ####"
        menu_items = Renalware::System::ViewMetadata
          .distinct("scope")
          .where(category: :mdm)
          .order(:title)
          .pluck(:scope, :title)
          .each_with_object({}) { |row, hash| hash[row[0]] = row[1] }

        sanitize_menu_definitions(menu_items)
      end

      # Only accept MDM scopes names that are simple lower case underscored strings eg "hd".
      # For the menu title use #title if present and is not0 "All" otherwise use the scope.
      def self.sanitize_menu_definitions(definitions)
        definitions
          .select { |scope, _title| scope.match(/^[a-z0-9_]*$/) }
          .each_with_object({}) do |key_and_value, new_hash|
            scope, title = key_and_value
            new_hash[scope] = if title.present? && title&.downcase != "all"
                                title
                              else
                                scope.humanize
                              end
          end
      end

      private_class_method :menu_definitions
      private_class_method :cached_items
    end
  end
end
