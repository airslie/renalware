module Renalware
  module Medications
    module HomeDelivery
      # Works with a modal.
      class EventsController < BaseController
        # GET PDF - display the pdf
        def show
          event = find_and_auth_event
          respond_to do |format|
            format.pdf { render_renalware_forms_pdf(event) }
          end
        end

        # A major REST faux pas, our #new action actually creates something - an instance of a
        # HomeDelivery::Event. We use this to render a modal form where the user can choose which
        # drug types they want to print a PDF for, and what some parameters are for the PDF
        # e.g. the prescription duration. See also Drugs::HomecareForm.
        # The overall idea is that when you bring up the modal dialog to print a home delivery PDF
        # there is always an Event object created behind it, and when you change the params (drug
        # type, prescription duration) it updates the stored event, ready for printing.
        # Although this means we might create rows that are never printed if the user cancels out
        # of the dialog, this is OK as the #printed flag will not be set on those rows so they can
        # be housekept away
        def new
          homecare_form = Drugs::HomecareForm.first

          event = Delivery::Event.create!(
            patient: patient,
            drug_type_id: homecare_form&.drug_type&.id,
            homecare_form: homecare_form,
            reference_number: Medications::Delivery::PurchaseOrderNumber.next,
            prescription_duration: homecare_form&.prescription_duration_default,
            by: current_user
          )
          authorize event

          event.prescriptions = prescriptions_for(event)
          event.valid?
          render(:edit, layout: false, locals: { event: event })
        end

        # Once #new is called when the modal is first displayed, successive updates come in here
        def update # rubocop:disable Metrics/AbcSize
          event = find_and_auth_event
          event.assign_attributes(event_params)
          event.homecare_form = homecare_form_for(event)
          event.prescriptions = prescriptions_for(event)

          if event.changed.include?("drug_type_id")
            event.prescription_duration = event.homecare_form&.prescription_duration_default
          end
          event.printed = event_params[:printed].present? # button

          if event.update_by(current_user, {})
            if event.printed?
              # If printed == true that means the user has clicked on the 'Printed' successfully
              # so we just hide the modal - we are done.
              event.update!(printed: true)
              event.prescriptions.each do |pres|
                last_delivery_date = Time.zone.today
                unit_count = event.prescription_duration.to_i
                unit = event.homecare_form.prescription_duration_unit.to_sym
                next_delivery_date = last_delivery_date + unit_count.send(unit) # eg. 6.months

                pres.update_columns(
                  last_delivery_date: last_delivery_date,
                  next_delivery_date: next_delivery_date
                )
              end
              render :update, locals: { event: event }
            else
              # The user has updated the drug id or prescription duration in the dialog
              # and we have come in here as an ajax PATCH as a result. We are updating the event as
              # the options are changes in the dialog, so when the clicks on the Print link, the
              # event reflects the chosen options.
              render :edit, locals: { event: event }
            end
          else
            render :edit, locals: { event: event }
          end
        end

        private

        def prescriptions_for(event)
          PrescriptionsByDrugTypeIdQuery.new(
            patient: event.patient,
            drug_type_id: event.drug_type_id,
            provider: :home_delivery
          ).call
        end

        def render_renalware_forms_pdf(event)
          pdf = Medications::Delivery::HomecareFormsAdapter.new(delivery_event: event).call
          send_data(
            pdf.render,
            filename: pdf_filename_for(event),
            type: "application/pdf",
            disposition: "inline"
          )
        end

        def event_is_valid_for_creating_a_homecare_pdf_form(event)
          event.errors.add(:homecare_form, "Ugh")
        end

        def pdf_filename_for(event)
          [patient.nhs_number, event.reference_number, "homecare"].join("-") + ".pdf"
        end

        def find_and_auth_event
          Delivery::Event.find(params[:id]).tap { |event| authorize event }
        end

        def homecare_form_for(event)
          Drugs::HomecareForm.find_by(drug_type_id: event.drug_type_id)
        end

        def event_params
          params
            .require(:event)
            .permit(:prescription_duration, :drug_type_id, :printed)
        end
      end
    end
  end
end
