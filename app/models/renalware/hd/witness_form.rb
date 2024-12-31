module Renalware
  module HD
    # Form object to help us update the PrescriptionAdministration#witnesses_by
    # See WitnessesController#edit/update and the corresponding html and js views.
    class WitnessForm
      include ActiveModel::Model
      include Virtus::Model

      attribute :user_id, Integer
      attribute :password, String
      attribute :prescription_administration_id, Integer
      attribute :update_user_only, Boolean

      validates :user_id, presence: true
      validates :prescription_administration_id, presence: true
      validates :password, presence: { unless: :update_user_only }
      validate :password_is_correct, unless: :update_user_only

      private

      def password_is_correct
        witness = User.find(user_id)
        unless witness.valid_password?(password)
          errors.add(:password, "Invalid password")
        end
      end
    end
  end
end
