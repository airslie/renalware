module Renalware
  module Letters
    class Author < Renalware::User
      # rubocop:disable Rails/RedundantForeignKey
      has_many :letters, dependent: :restrict_with_exception, foreign_key: :author_id
      # rubocop:enable Rails/RedundantForeignKey
    end
  end
end
