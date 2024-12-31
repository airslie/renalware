module Renalware
  module Feeds
    class FilePolicy < BasePolicy
      def destroy?    = false
      def edit?       = false
      def update?     = false
      def new         = developer?
      def create      = developer?
    end
  end
end
