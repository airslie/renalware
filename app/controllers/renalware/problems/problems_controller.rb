module Renalware
  module Problems
    class ProblemsController < BaseController
      include Renalware::Concerns::PatientVisibility
      after_action :track_action, except: [:search]

      skip_verify_policy_scoped only: :search

      PRB_PARAMS_DAY = "date(3i)".freeze
      PRB_PARAMS_MONTH = "date(2i)".freeze
      PRB_PARAMS_YEAR = "date(1i)".freeze

      def index
        problems = patient.problems.with_notes
        authorize problems
        render locals: {
          patient: patient,
          problem: patient.problems.build(date: nil),
          current_problems: CollectionPresenter.new(problems.current, ProblemPresenter),
          archived_problems: CollectionPresenter.new(problems.archived, ProblemPresenter)
        }
      end

      def search
        authorize Problem, :search?

        nhs_client.query(params[:term], count: 10, offset: 10 * params[:page].to_i)
        problems = nhs_client.problems.each do |p|
          p[:id] = p["display"]
          p[:text] = p["display"]
        end
        problems_total = nhs_client.problems_total

        render json: { problems: problems, problems_total: problems_total }
      end

      def show
        problem = patient.problems.with_archived.with_versions.find(params[:id])
        notes = problem.notes.with_updated_by.ordered
        authorize problem
        render locals: {
          patient: patient,
          problem: ProblemPresenter.new(problem),
          notes: notes
        }
      end

      def edit
        problem = find_problem
        authorize problem
        render locals: {
          patient: patient,
          problem: problem
        }
      end

      def create
        problem = patient.problems.new(problem_params)
        authorize problem
        if problem.save
          render(
            partial: "current_problem",
            locals: { problem: ProblemPresenter.new(problem) },
            status: :created
          )
        else
          render json: problem.errors.full_messages, status: :not_acceptable
        end
      end

      def update
        authorize(problem = find_problem)

        if update_problem(problem)
          redirect_to patient_problem_path(patient, problem), notice: success_msg_for("problem")
        else
          flash.now[:error] = failed_msg_for("problem")
          render :edit, locals: {
            patient: patient,
            problem: problem
          }
        end
      end

      def destroy
        problem = find_problem
        authorize problem
        problem.by = current_user
        problem.save!
        problem.destroy
        redirect_to patient_problems_path(patient), notice: success_msg_for("problem")
      end

      def sort
        authorize Problem, :sort?
        ids = params[:problems_problem]
        Problem.sort(ids)
        render json: ids
      end

      private

      # If year is present but month or day not, set those to 01
      def fixup_onset_date_params
        prms = params[:problems_problem]
        if prms[PRB_PARAMS_YEAR].present?
          prms[PRB_PARAMS_MONTH] = prms[PRB_PARAMS_MONTH].presence || "1"
          prms[PRB_PARAMS_DAY] = prms[PRB_PARAMS_DAY].presence || "1"
        end
      end

      def find_problem
        patient.problems.find(params[:id])
      end

      def update_problem(problem)
        problem.assign_attributes(problem_params)
        problem.save
      end

      def derive_display_style
        day, month, year = [
          PRB_PARAMS_DAY,
          PRB_PARAMS_MONTH,
          PRB_PARAMS_YEAR
        ].map { |prm| params[:problems_problem][prm].present? }
        return "dmy" if day && month && year
        return "my" if month && year
        return "y" if year
      end

      def problem_params
        params[:problems_problem][:date_display_style] = derive_display_style
        fixup_onset_date_params
        params
          .require(:problems_problem)
          .permit(:description, :snomed_id, :date, :date_display_style)
          .merge(by: current_user)
      end
    end
  end
end
