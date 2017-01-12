require_dependency "renalware/transplants"
require "document/base"

module Renalware
  module Transplants
    class RecipientWorkup < ApplicationRecord
      include Document::Base
      include PatientScope

      belongs_to :patient

      has_paper_trail class_name: "Renalware::Transplants::Version"
      has_document class_name: "Renalware::Transplants::RecipientWorkupDocument"
    end
  end
end
