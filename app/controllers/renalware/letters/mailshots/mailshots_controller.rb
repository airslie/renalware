module Renalware
  module Letters
    module Mailshots
      class MailshotsController < BaseController
        include Pagy::Backend

        def index
          pagy, mailshots = pagy(Mailshot.includes(:author).order(created_at: :desc))
          authorize mailshots
          render locals: { mailshots: mailshots, pagy: pagy }
        end

        def new
          mailshot = Mailshot.new
          authorize mailshot
          render_new(mailshot)
        end

        def create
          mailshot = Mailshot.new(mailshot_params)
          authorize mailshot, :create?
          mailshot.letters_count = mailshot.recipient_patients.length
          mailshot.status = "queued"

          if mailshot.save_by(current_user)
            CreateMailshotLettersJob.perform_later(mailshot)
            redirect_to letters_mailshots_path, notice: "Mailshot queued for background processing"
          else
            render_new(mailshot)
          end
        end

        private

        def render_new(mailshot)
          render :new, locals: { mailshot: mailshot }
        end

        def mailshot_params
          params
            .require(:mailshot)
            .permit(
              :letterhead_id, :description, :author_id, :body, :sql_view_name
            )
        end
      end
    end
  end
end
