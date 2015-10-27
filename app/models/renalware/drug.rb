module Renalware
  class Drug < ActiveRecord::Base

    acts_as_paranoid

    has_many :medications, as: :medicatable, dependent: :destroy
    has_many :patients, through: :medications, as: :medicatable
    has_and_belongs_to_many :drug_types

    validates :name, presence: true

    scope :antibiotic, -> { joins(:drug_types).where(:drug_types => {:name => "Antibiotic"}) }
    scope :esa, -> { joins(:drug_types).where(:drug_types => {:name => "ESA"}) }
    scope :immunosuppressant, -> { joins(:drug_types).where(:drug_types => {:name => "Immunosuppressant"}) }
    scope :peritonitis, -> { joins(:drug_types).where(:drug_types => {:name => "Peritonitis"}) }

    def display_type
      "Standard Drug"
    end
  end
end
