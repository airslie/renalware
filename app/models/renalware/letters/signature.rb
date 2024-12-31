module Renalware
  module Letters
    class Signature < ApplicationRecord
      belongs_to :user, touch: true
      belongs_to :letter, touch: true

      validates :user, presence: true
      validates :letter, presence: true
      validates :signed_at, presence: true

      def to_s
        name = user.full_name
        time = I18n.l(signed_at, format: :time)
        date = I18n.l(signed_on)
        "Electronically signed by #{name} at #{time} on #{date}".upcase
      end

      def signed_on
        signed_at.to_date
      end
    end
  end
end
