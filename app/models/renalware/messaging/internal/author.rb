module Renalware
  module Messaging
    # TODO: Document the Internal module
    module Internal
      class Author < Renalware::User
        # rubocop:disable Rails/RedundantForeignKey
        has_many :messages, dependent: :destroy, foreign_key: :author_id
        # rubocop:enable Rails/RedundantForeignKey

        def self.model_name = ActiveModel::Name.new(self, nil, "User")
      end
    end
  end
end
