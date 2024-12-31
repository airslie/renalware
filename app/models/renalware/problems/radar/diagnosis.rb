module Renalware
  module Problems
    module RaDaR
      # See https://ukkidney.org/rare-renal/radar
      # The National Registry of Rare Kidney Diseases (RaDaR) is a Renal Association initiative
      # designed to pull together information from patients with certain rare kidney diseases.
      # As of 1st Sept 2022 there are 29,500 UK patients recruited into RaDaR from 107 sites.
      # An example diagnosis is 'Adenine Phosphoribosyltransferase Deficiency (APRT-D)' which
      # belongs to the cohort 'APRT Deficiency'
      class Diagnosis < ApplicationRecord
        validates :name, presence: true
        belongs_to :cohort
      end
    end
  end
end
