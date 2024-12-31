module Renalware
  module Authoring
    class Snippet < ApplicationRecord
      include RansackAll

      validates :title, presence: true, uniqueness: { scope: :author }
      validates :body, presence: true
      validates :author, presence: true
      validates :times_used, presence: true, numericality: { only_integer: true }
      validates :times_used, numericality: { only_integer: true }

      belongs_to :author,
                 class_name: "Renalware::Authoring::User",
                 inverse_of: :snippets

      def record_usage
        increment(:times_used)
        self.last_used_on = Time.zone.now
        save!
        self
      end
    end
  end
end
