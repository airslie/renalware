# Not using refinements here as we cannot define constants using refinements.
# We include this module in config/initializers/core_extensions.rb
module CoreExtensions
  module Date
    module Constants
      DAYNAME_SYMBOLS = ::Date::DAYNAMES.map { |name| name.underscore.to_sym }.freeze
    end
  end
end
