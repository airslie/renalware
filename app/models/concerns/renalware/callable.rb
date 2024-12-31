module Renalware
  module Callable
    # Adds a #call class method that will instantiate the class, passing any args to #initialize,
    # and then invoke instance#call (without args).
    extend ActiveSupport::Concern

    class_methods do
      def call(...)
        new(...).call
      end
    end
  end
end
