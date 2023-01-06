# frozen_string_literal: true

require "document/base"

module Renalware
  module Virology
    class Profile < ApplicationRecord
      include Accountable
      include Document::Base
      belongs_to :patient, touch: true
      has_document class_name: "Renalware::Virology::ProfileDocument"
    end
  end
end
