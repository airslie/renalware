# frozen_string_literal: true

require_dependency "renalware/ukrdc"

module Renalware
  module UKRDC
    # Represents a Renal Reg modality QBL or Text code and description
    # e.g. (1) Haemodialysis
    # TXT refers to Renal Reg Patient timeline information
    # QBL refers to Renal Reg Patient monthy treatment history
    class ModalityCode < ApplicationRecord
    end
  end
end
