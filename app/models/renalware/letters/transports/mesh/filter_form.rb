# frozen_string_literal: true

module Renalware
  module Letters::Transports::Mesh
    # Form object to help us build and parse the appropriate filters for the
    # mesh letters controller.
    class FilterForm
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :s, :string # sort order, not really part of the form
      attribute :gp_send_status_in, :string
      attribute :ods_code_mismatch_eq, :boolean
      attribute :author_id_eq, :integer
      attribute :typist_id_eq, :integer
    end
  end
end
