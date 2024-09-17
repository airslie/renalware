# frozen_string_literal: true

module Renalware
  module Letters::Transports::Mesh
    class LettersController < BaseController
      include Pagy::Backend
      layout -> { turbo_frame_request? ? "turbo_rails/frame" : "renalware/layouts/simple" }

      def index
        authorize Letters::Letter, :index?
        form = FilterForm.new(filter_parameters)
        search = Letters::Transports::Mesh::Letter.ransack(**form.attributes)
        q = search.result
        pagy, letters = pagy(search.result)

        render locals: { pagy: pagy, letters: letters, q: q, form: form }
      end

      def filter_parameters
        return {} unless params.key?(:q)

        params
          .require(:q)
          .permit(:gp_send_status_in, :ods_code_mismatch_eq, :author_id_eq, :typist_id_eq, :s)
      end
    end
  end
end
