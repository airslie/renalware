module Renalware
  module Authoring
    class User < Renalware::User
      has_many :snippets,
               inverse_of: :author,
               foreign_key: :author_id,
               dependent: :restrict_with_exception

      def self.model_name = ActiveModel::Name.new(self, nil, "User")
    end
  end
end
