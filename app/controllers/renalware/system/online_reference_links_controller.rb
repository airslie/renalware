# frozen_string_literal: true

module Renalware
  module System
    class OnlineReferenceLinksController < BaseController
      include Pagy::Backend

      def index
        ransack_params = params[:q] || {}
        search = OnlineReferenceLink
          .includes(:updated_by)
          .order(title: :asc).ransack(ransack_params)
        pagy, references = pagy(search.result)
        authorize references
        render locals: { references: references, search: search, pagy: pagy }
      end

      def search
        index
      end

      def new
        reference = OnlineReferenceLink.new
        authorize reference
        render_new(reference)
      end

      def edit
        render_edit(find_and_authorize_reference)
      end

      def create
        reference = OnlineReferenceLink.new(online_reference_params)
        authorize reference
        if reference.save_by(current_user)
          redirect_to system_online_reference_links_path
        else
          render_new(reference)
        end
      end

      def update
        reference = find_and_authorize_reference
        if reference.update_by(current_user, online_reference_params)
          redirect_to system_online_reference_links_path
        else
          render_edit(reference)
        end
      end

      private

      def find_and_authorize_reference
        OnlineReferenceLink.find(params[:id]).tap { |ref| authorize ref }
      end

      def render_new(reference)
        render(:new, locals: { reference: reference })
      end

      def render_edit(reference)
        render(:edit, locals: { reference: reference })
      end

      def online_reference_params
        params
          .require(:system_online_reference_link)
          .permit(:description, :title, :url, :include_in_letters_from, :include_in_letters_until)
      end
    end
  end
end
