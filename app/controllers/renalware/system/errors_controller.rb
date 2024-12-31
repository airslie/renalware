module Renalware
  module System
    class ErrorsController < ApplicationController
      layout "renalware/layouts/error"

      def show
        env = request.env
        @exception       = env["action_dispatch.exception"]
        @status_code     = ActionDispatch::ExceptionWrapper.new(env, @exception).status_code
        @rescue_response = ActionDispatch::ExceptionWrapper.rescue_responses[@exception.class.name]

        respond_to do |format|
          format.html { render :show, status: @status_code, layout: !request.xhr? }
          format.xml  { render xml: safe_details, root: "error", status: @status_code }
          format.json { render json: { error: safe_details }, status: @status_code }
        end
      end

      # A custom action for an Azure robotsXXX.txt (eg robots456.txt) healthcheck request.
      # As long as we return a 404, Azure knows we are running. See routes/fallbacks.
      def not_found_for_healthcheck
        render plain: "404 Not Found", status: :not_found
      end

      def generate_test_internal_server_error
        raise "This is an intentionally raised error - please ignore it. " \
              "It is used only to test system integration. " \
              "The rest of this messages is padding to test that the title is truncated to 256 " \
              "characters#{'.' * 100}"
      end

      def safe_details = details.slice(:name, :message)

      # See config/locales/renalware/errors.en.yml
      def details # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        @details ||= {}.tap do |h|
          I18n.with_options(
            scope: [:exception, :show, @rescue_response],
            exception_name: @exception.class.name,
            exception_message: @exception.message
          ) do |i18n|
            h[:name] = i18n.t(
              "#{@exception.class.name.underscore}.title",
              default: i18n.t(:title, default: @exception.class.name)
            )
            h[:message] = i18n.t(
              "#{@exception.class.name.underscore}.description",
              default: i18n.t(:description, default: @exception.message)
            )
            h[:detail_name] = @exception.class.name
            h[:detail_description] = @exception.full_message
          end
        end
      end
      helper_method :details
    end
  end
end
