# frozen_string_literal: true

module Renalware
  module Drugs
    class Type < ApplicationRecord
      has_many :classifications, foreign_key: :drug_type_id, dependent: :destroy
      has_many :drugs, through: :classifications

      has_paper_trail(
        versions: { class_name: "Renalware::Drugs::Version" },
        on: [:create, :update, :destroy]
      )

      include OrderedSetScope

      def self.for(*codes)
        includes(:drugs)
          .ordered_set(:code, codes)
      end
    end
  end
end
