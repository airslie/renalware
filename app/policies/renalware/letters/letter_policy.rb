# frozen_string_literal: true

module Renalware
  module Letters
    class LetterPolicy < BasePolicy
      alias_attribute :letter, :record

      def author?
        write_privileges?
      end

      def update?
        false
      end

      def submit_for_review?
        false
      end

      def reject?
        false
      end

      def approve?
        false
      end

      def complete?
        false
      end

      def destroy?
        return false if user_is_read_only?
        return false if %i(approved completed).include?(letter_state)

        user_is_admin? ||
          user_is_super_admin? ||
          letter.author == user ||
          letter.created_by == user
      end

      private

      def letter_state
        record.state.downcase.to_sym
      end
    end
  end
end
