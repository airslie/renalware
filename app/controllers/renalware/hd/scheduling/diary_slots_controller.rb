# frozen_string_literal: true

module Renalware
  module HD
    module Scheduling
      class DiarySlotsController < BaseController
        # GET .js refresh a slot in a *weekly* diary
        # See comment on #create.
        # See show.js.erb where we refresh the slot in the diary
        # To get here we will have manufactured a url like this
        #   hd/diaries/2/slots/day/1/period/1/station/1
        # as those bit are will we know.
        # Basically we are saying find for this weekly diary, find the matching
        # slot for the station/day/period combo and render the weekly slot if there is
        # one, or the master behind it if there is one of those, otherwise render an Add button.
        def show
          authorize DiarySlot, :show?
          slot = weekly_then_master_then_empty_slot
          render layout: false, locals: { slot: DiarySlotPresenter.new(slot) }
        end

        # GET html -  renders a form
        # Here we will have been passed in the query string:
        # - the unit id
        # - the diurnal_period_code id
        # - the week and year (and thus the diary)
        # and from that lot we could look up the master and weekly diaries
        def new
          # Be default this assume we are going to add a slot to the weekly diary
          # but in which button is clicked in the modal dialog determines which diary
          # (master or weekly) the slot will be added to.
          slot = DiarySlot.new(
            diary: weekly_diary,
            station_id: params[:station_id],
            day_of_week: params[:day_of_week],
            diurnal_period_code_id: params[:diurnal_period_code_id],
            patient_search_scope: patient_search_scope_from_query_string
          )
          authorize slot
          render locals: locals_for(slot), layout: false
        end

        def edit
          authorize slot
          slot.patient_search_scope = patient_search_scope_from_query_string
          render layout: false, locals: { slot: DiarySlotPresenter.new(slot) }
        end

        # POST create js
        # Here we may be adding a slot to the weekly or master diary.
        # That should be transparent to us - we make the change and render
        # create.js.erb which, on the client, will cause an ajax js call to #show.
        # That secondary call is the one that refreshes the slot in the table with its latest state.
        # We do this to avoid having to do a check (in each action in this controller) to see if we
        # are on the master or weekly diary; if we always refresh the diary slot in the ui after any
        # action, then it will always update correctly.
        def create
          diary = Diary.find(params[:diary_id])
          slot = diary.slots.new(slot_params)
          # slot.patient_id = posted_patient_id
          authorize slot
          if slot.save_by(current_user)
            render locals: { diary: diary, slot: diary.decorate_slot(slot) }
          else
            render :new, locals: { slot: DiarySlotPresenter.new(slot) }, layout: false
          end
        end

        # PATCH js
        # See also comments in #create and #destroy.
        # Here we only update the patient's arrival_time. We don't change the patient ot diary.
        def update
          authorize slot
          slot.arrival_time = slot_params[:arrival_time]
          slot.save_by!(current_user)
          diary = slot.diary
          render locals: { diary: diary, slot: diary.decorate_slot(slot) }
        end

        # DELETE js
        # Delete the slot (we don't know if its on the master or weekly diary).
        # NB as per #create and #update, the rendered js file (destroy.js.erb) will make a secondary
        # call back into #show to refresh the UI (i.e. we don't attempt to update the UI in
        # destroy.js.erb)
        def destroy
          authorize slot
          slot.destroy!
          render locals: { slot: DiarySlotPresenter.new(slot) }
        end

        private

        def patient_search_scope_from_query_string
          params.fetch(:patient_search_scope, :dialysing_on_day_and_period)
        end

        # Find the corresponding slot in the master if there is one, otherwise an empty slot
        # with an 'Add' button ready to set up a new patient
        def weekly_then_master_then_empty_slot
          empty_slot = build_empty_weekly_slot
          find_weekly_slot(empty_slot) || find_master_slot(empty_slot) || empty_slot
        end

        def find_master_slot(args)
          slot = master_diary.slots.find_by(
            diurnal_period_code_id: args.diurnal_period_code_id,
            station_id: args.station_id,
            day_of_week: args.day_of_week
          )
          slot && master_diary.decorate_slot(slot)
        end

        def find_weekly_slot(args)
          slot = weekly_diary.slots.find_by(
            diurnal_period_code_id: args.diurnal_period_code_id,
            station_id: args.station_id,
            day_of_week: args.day_of_week
          )
          slot && weekly_diary.decorate_slot(slot)
        end

        # Used for searching etc
        def build_empty_weekly_slot
          weekly_diary.slots.new(
            day_of_week: params[:day_of_week],
            station_id: params[:station_id],
            diurnal_period_code_id: params[:diurnal_period_code_id]
          )
        end

        def slot
          @slot ||= DiarySlot.find(params[:id])
        end

        # In the url the :diary_id param is always the weekly diary id!
        def weekly_diary
          @weekly_diary ||= WeeklyDiary.find(params[:diary_id])
        end

        def master_diary
          weekly_diary.master_diary
        end

        def locals_for(slot)
          {
            slot: DiarySlotPresenter.new(slot),
            weekly_diary: weekly_diary
          }
        end

        def posted_patient_id
          slot_params[:patient_id]
        end

        def slot_params
          params
            .require(:slot)
            .permit(
              :master_slot,
              :day_of_week,
              :diurnal_period_code_id,
              :station_id,
              :target_diary_id,
              :patient_search_scope,
              :patient_id,
              :arrival_time
            )
        end
      end
    end
  end
end
