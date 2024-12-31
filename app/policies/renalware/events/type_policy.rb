module Renalware
  module Events
    class TypePolicy < EventPolicy
      delegate :subtypes?, to: :record

      def destroy?
        user_is_super_admin? &&
          record.slug.blank? &&
          record.deleted_at.nil?
      end

      def edit?
        user_is_super_admin? && record.deleted_at.nil?
      end
      alias update? edit?
    end
  end
end
