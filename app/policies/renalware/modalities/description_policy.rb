module Renalware
  module Modalities
    class DescriptionPolicy < BasePolicy
      def index? = user_is_any_admin?
      alias show? index?

      def new? = user_is_super_admin?
      alias create? new?

      # Its only possible to edit a ModalityDescription (e.g. to change its name) when it has no
      # (STI) type - ie its not a system-required ModalityDescription.
      def edit? = user_is_super_admin? && record.type.nil?
      alias update? edit?

      # For safety we disallow the deletion of any ModalityDescription
      def destroy? = false
    end
  end
end
