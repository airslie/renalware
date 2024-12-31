# The route to the edit route for this controller takes /:year/:week_number segments
# rather than an id. THat is because when we load the diary, and when we navigate back and forth
# through diaries, we are concerned with the week more then an id. Its easier to navigate to the
# next week with /2017/52 than by looking up the id of the next diary ahead of time.
module Renalware
  module HD
    module Scheduling
      class DiariesController < BaseController
        include Renalware::Concerns::PdfRenderable
        include Pagy::Backend

        # Renders a list of diaries for a hospital unit
        def index
          authorize WeeklyDiary, :index?
          pagy, weekly_diaries = pagy(weekly_diaries_for_unit)
          render locals: { unit: unit, pagy: pagy, diaries: weekly_diaries }
        end

        def show
          diary = WeeklyDiary.find(params[:id])
          respond_to do |format|
            format.pdf do
              authorize diary
              options = default_pdf_options.merge!(
                pdf: pdf_filename,
                locals: { unit: unit, diary: DiaryPresenter.new(current_user, diary) }
              )
              render_with_wicked_pdf options
            end
          end
        end

        def edit
          authorize weekly_diary, :show?
          render locals: {
            unit: unit,
            diary: DiaryPresenter.new(current_user, weekly_diary)
          }
        end

        private

        # TODO: give a sensible name
        def pdf_filename
          "hd_unit_diary"
        end

        def weekly_diary
          @weekly_diary ||= begin
            FindOrCreateDiaryByWeekQuery.new(
              relation: WeeklyDiary.eager_load(
                slots: %i(patient station diurnal_period_code),
                master_diary: { slots: %i(patient station diurnal_period_code) }
              ),
              unit_id: unit_id,
              week_period: week_period,
              by: current_user
            ).call
          end
        end

        # The route segments are /:year/:week_number
        # We use a WeekPeriod value object to wrap those two things.
        def week_period
          WeekPeriod.new(
            week_number: params[:week_number],
            year: params[:year]
          )
        end

        def unit_id
          params[:unit_id]
        end

        def unit
          Hospitals::Unit.find(unit_id)
        end

        def weekly_diaries_for_unit
          WeeklyDiary
            .where(hospital_unit_id: unit_id)
            .ordered
        end
      end
    end
  end
end
