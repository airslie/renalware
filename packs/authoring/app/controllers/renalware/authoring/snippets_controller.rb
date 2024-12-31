module Renalware
  module Authoring
    class SnippetsController < BaseController
      include Pagy::Backend

      # rubocop:disable Metrics/MethodLength
      def index
        authorize Snippet, :index?
        snippets = snippets_for_author(author)
        search = snippets.ransack(params[:q])
        search.sorts = ["times_used desc", "last_used_on desc"] if search.sorts.empty?
        pagy, snippets = pagy(search.result, limit: 10)
        in_dialog = ActiveModel::Type::Boolean.new.cast(params.fetch(:in_dialog, true))
        locals = {
          snippets: snippets,
          search: search,
          author: author,
          pagy: pagy,
          in_dialog: in_dialog
        }

        template = turbo_frame_request? ? "dialog" : "index"

        render template, locals: locals, layout: !turbo_frame_request?
      end
      # rubocop:enable Metrics/MethodLength

      def new
        authorize(snippet = new_snippet)
        render locals: { snippet: snippet }
      end

      def edit
        snippet = find_and_authorize_snippet
        render :edit, locals: { snippet: snippet }
      end

      def create
        snippet = Snippet.new(snippet_params)
        snippet.author = Authoring.cast_user(current_user)
        authorize snippet

        if snippet.save
          redirect_to authoring.snippets_path, notice: success_msg_for("snippet")
        else
          render :new, locals: { snippet: snippet }
        end
      end

      def update
        snippet = find_and_authorize_snippet
        if snippet.update(snippet_params)
          redirect_to authoring.snippets_path, notice: success_msg_for("snippet")
        else
          render :edit, locals: { snippet: snippet }
        end
      end

      def destroy
        snippet = find_and_authorize_snippet
        snippet.destroy!
        flash[:notice] = success_msg_for("snippet")
        redirect_to authoring.snippets_path
      end

      private

      def snippets_for_author(author)
        user = author == :me ? current_user : nil
        SnippetQuery.new(author: user).call
      end

      def author
        @author ||= begin
          author = params.fetch(:author, :me).to_sym
          author = :me unless %i(me anyone).include?(author)
          author
        end
      end

      def new_snippet
        id = params[:id_of_snippet_to_duplicate]
        id.present? ? duplicate_snippet(id) : Snippet.new
      end

      def duplicate_snippet(id)
        original_snippet = Snippet.find(id)
        Snippet.new(title: original_snippet.title, body: original_snippet.body)
      end

      def find_and_authorize_snippet
        snippet = Snippet.find(params[:id])
        authorize snippet
        snippet
      end

      def snippet_params
        params.require(:snippet).permit(%i(title body))
      end
    end
  end
end
