module Renalware
  module Letters::Transports::Mesh
    # Backed by view renalware.letters_mesh_letter
    class Letter < ApplicationRecord
      include RansackAll
      def self.table_name = :letter_mesh_letters
      scope :ordered, -> { order(id: :desc) }
    end
  end
end
