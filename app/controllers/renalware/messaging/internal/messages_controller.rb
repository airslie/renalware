module Renalware
  module Messaging
    module Internal
      class MessagesController < BaseController
        include Renalware::Concerns::Pageable
        include PresenterHelper
        include Pagy::Backend

        # Display all public message for a patient
        def index
          authorize Messaging::Internal::Message, :index?
          scope = patient.messages.where(public: true).order(created_at: :desc)
          pagy, messages = pagy(scope, items: 20)
          render locals: { patient: patient, messages: messages, pagy: pagy }
        end

        def new
          authorize Messaging::Internal::Message, :new?
          form = MessageFormBuilder.new(
            patient: patient,
            current_user: current_user,
            params: params
          ).call
          render_new(form)
        end

        def create
          authorize Messaging::Internal::Message, :create?
          form = MessageForm.new(message_params)

          if form.valid?
            new_message = SendMessage.call(author: author, patient: patient, form: form)
            mark_receipt_as_read_if_replying_to_existing_message(form)
            flash.now[:notice] = "Message was successfully sent"
            render_create(new_message)
          else
            render_new(form)
          end
        end

        private

        def mark_receipt_as_read_if_replying_to_existing_message(form)
          return if form.replying_to_message_id.blank?

          message_we_are_replying_to = Message.find(form.replying_to_message_id)
          message_we_are_replying_to
            .receipts
            .where(recipient_id: current_user.id)
            .update!(read_at: Time.zone.now)
        end

        def patient
          Messaging.cast_patient(Patient.find(params[:patient_id]))
        end

        def message_we_are_replying_to(message)
          return if message.replying_to_message_id.blank?

          MessagePresenter.new(message.replying_to_message)
        end

        def render_new(form)
          render :new,
                 locals: {
                   form: form,
                   recipient_options: RecipientOptions.new(patient, author).to_a,
                   patient: patient
                 },
                 layout: false
        end

        def render_create(message)
          render locals: {
            message: MessagePresenter.new(message),
            original_message: message_we_are_replying_to(message)
          }
        end

        def author
          Messaging::Internal.cast_author(current_user)
        end

        def message_params
          params
            .require(:internal_message)
            .permit(:subject, :body, :urgent, :replying_to_message_id, :public, recipient_ids: [])
        end
      end
    end
  end
end
