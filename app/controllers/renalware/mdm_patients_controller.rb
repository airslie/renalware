# frozen_string_literal: true

# Note we rely on template inheritance with this MDM Base class i.e. subclasses (e.g.
# HD::MDMPatientsController) can override templates and partials (e.g. add a _filters partial
# or override the _patient partial to replace what is displayed in the table).
# Otherwise the default template location is of course app/views/renalware/mdm_patients.
module Renalware
  class MDMPatientsController < BaseController
    include PresenterHelper
    include Renalware::Concerns::Pageable

    protected

    def render_index(**args)
      presenter = build_presenter(params: params, **args)
      authorize presenter.patients
      render :index, locals: { presenter: presenter }
    end

    def build_presenter(**args)
      query = args.fetch(:query)

      MDMPatientsPresenter.new(
        patients: query.call.page(page).per(per_page),
        page_title: args.fetch(:page_title),
        view_proc: args.fetch(:view_proc),
        q: query.search,
        patient_presenter_class: args[:patient_presenter_class]
      )
    end
  end
end
