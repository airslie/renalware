module Renalware
  module Problems
    class NotesController < BaseController
      include Renalware::Concerns::PatientVisibility

      def index
        render_index
      end

      def new
        note = problem.notes.new
        authorize(note)
        render_form(
          note,
          url: patient_problem_notes_path(patient, problem)
        )
      end

      def edit
        authorize note
        render_form(
          note,
          url: patient_problem_note_path(patient, problem, note)
        )
      end

      def create
        note = problem.notes.create(notes_params)
        authorize(note)
        if note.save
          render_index
        else
          render_form(
            note,
            url: patient_problem_notes_path(patient, problem)
          )
        end
      end

      def update
        authorize note
        if note.update_by(current_user, notes_params)
          render_index
        else
          render_form(
            note,
            url: patient_problem_notes_path(patient, problem)
          )
        end
      end

      def destroy
        authorize note
        note.destroy!
        render_index
      end

      private

      def problem
        @problem ||= patient.problems.find(params[:problem_id])
      end

      def notes
        @notes ||= problem.notes.includes(:updated_by).ordered
      end

      def note
        notes.find(params[:id])
      end

      def render_index
        authorize(notes)
        render "index", locals: { problem: problem, notes: notes }
      end

      def render_form(note, url:)
        render "form", locals: { problem: problem, note: note, url: url }
      end

      def notes_params
        params.require(:problems_note).permit(:description).merge(by: current_user)
      end
    end
  end
end
