module Renalware
  module System
    class MessagesController < BaseController
      def index
        messages = Message.order(created_at: :desc)
        authorize messages
        render locals: { messages: messages }
      end

      def new
        message = System::Message.new
        authorize message
        render_new(message)
      end

      def edit
        render_edit(find_and_authorise_message)
      end

      def create
        message = System::Message.new(message_params)
        authorize message
        if message.save
          redirect_to system_messages_path
        else
          render_new(message)
        end
      end

      def update
        message = find_and_authorise_message
        if message.update(message_params)
          redirect_to system_messages_path
        else
          render_edit(message)
        end
      end

      def destroy
        find_and_authorise_message.destroy!
        redirect_to system_messages_path
      end

      private

      def render_new(message)
        render :new, locals: { message: message }
      end

      def render_edit(message)
        render :edit, locals: { message: message }
      end

      def message_params
        params
          .require(:message)
          .permit(:title, :body, :severity, :message_type, :display_from, :display_until)
      end

      def find_and_authorise_message
        message = Message.find(params[:id])
        authorize message
        message
      end
    end
  end
end
