module Renalware
  module Letters
    module Mailshots
      # Called via ajax from the new mailshot form, and responsible for taking the
      # SQL view the user has chosen as the mailshot datasource, and returning a list of
      # patients that the user can see and check before going on to create the mailshot.
      class PatientPreviewsController < BaseController
        include Pagy::Backend

        # Note we use data-remote as we want the table where the previewed patients are
        # displayed to have pagination links that work via ajax and do not refresh the page.
        def index
          authorize Patient, :index?
          pagy, patients = pagy(
            Mailshot.new(sql_view_name: sql_view_name).recipient_patients,
            anchor_string: "data-remote='true'"
          )
          render locals: {
            patients: patients,
            pagy: pagy,
            datasource: DataSource.find_by(viewname: sql_view_name)
          }
        end

        private

        # The user will have selected a view name from the dropdown onm the form.
        # This is the name of a SQL view in the database in the format
        # letter_mailshot_xxxxxx eg letter_mailshot_tx_patients.
        # See help text on the html form for an example of a SQL view.
        def sql_view_name
          params.dig(:mailshot, :sql_view_name)
        end
      end
    end
  end
end
