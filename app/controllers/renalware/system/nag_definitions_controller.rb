module Renalware
  module System
    class NagDefinitionsController < BaseController
      def index
        definitions = NagDefinition.order(importance: :asc)
        authorize definitions
        render locals: { definitions: definitions }
      end

      def new
        definition = NagDefinition.new
        authorize definition
        render_new(definition)
      end

      def create
        scope = scope_derived_from_chosen_function
        definition = NagDefinition.new(nag_params.merge(scope: scope))
        authorize definition
        if definition.save
          redirect_to system_nag_definitions_path
        else
          render_new(definition)
        end
      end

      def scoped_nag_sql_function_names
        {
          patient: SqlFunction.nag_functions_for_scope(:patient).map(&:sql_function_name),
          user: SqlFunction.nag_functions_for_scope(:user).map(&:sql_function_name)
        }
      end

      private

      # The NagDefinition stores a 'scope' which is not collected in the UI (we just ask for the
      # function name) so extract the scope from the start of the
      # If the function name is e.g. "patient_nag_x_y_z" then will return "patient"
      def scope_derived_from_chosen_function
        return if nag_params[:sql_function_name].blank?

        match = nag_params[:sql_function_name].match(/^(patient|user)_/)
        match&.captures&.first
      end

      def render_new(definition)
        render(
          :new,
          locals: {
            definition: definition,
            scoped_nag_sql_function_names: scoped_nag_sql_function_names
          }
        )
      end

      def nag_params
        params
          .require(:system_nag_definition)
          .permit(:description, :title, :hint, :importance, :sql_function_name, :relative_link)
      end
    end
  end
end
