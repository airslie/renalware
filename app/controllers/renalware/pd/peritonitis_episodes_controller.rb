module Renalware
  module PD
    class PeritonitisEpisodesController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::PdfRenderable
      include PresenterHelper

      def show
        respond_to do |format|
          format.html { render_show }
          format.pdf  { render_show_as_pdf }
        end
      end

      def new
        render locals: {
          peritonitis_episode: new_episode,
          patient: pd_patient
        }
      end

      def edit
        render locals: {
          peritonitis_episode: current_episode,
          patient: pd_patient
        }
      end

      def create
        save_episode(new_episode)
      end

      def update
        save_episode(current_episode)
      end

      def save_episode(episode)
        command = SavePeritonitisEpisode.new(patient: pd_patient, episode: episode)
        command.subscribe(self)
        command.call(params: peritonitis_episode_params)
      end

      def save_success(episode)
        respond_to do |format|
          format.js do
            render locals: {
              peritonitis_episode: present(episode, PeritonitisEpisodePresenter),
              patient: pd_patient
            }
          end
          format.html { redirect_after_successful_save(episode) }
        end
      end

      def save_failure(episode)
        flash.now[:error] = failed_msg_for("peritonitis episode")
        action = action_name.to_sym == :create ? :new : :edit
        render action, locals: {
          peritonitis_episode: episode,
          patient: pd_patient
        }
      end

      private

      def render_show
        render :show, locals: locals_for_show
      end

      def render_show_as_pdf
        variables = {
          "patient" => Patients::PatientDrop.new(pd_patient),
          "renal_patient" => Renal::PatientDrop.new(pd_patient),
          "pd_patient" => PD::PatientDrop.new(pd_patient)
        }
        render_liquid_template_to_pdf(template_name: "peritonitis_episode_printable_form",
                                      filename: pdf_filename,
                                      variables: variables)
      end

      def pdf_filename
        "#{pd_patient.family_name}-#{pd_patient.hospital_identifier.id}" \
        "-PERI-EPISODE-#{current_episode.id}".upcase
      end

      def locals_for_show
        prescriptions = current_episode.prescriptions.ordered
        {
          patient: pd_patient,
          peritonitis_episode: present(current_episode, PeritonitisEpisodePresenter),
          prescriptions: present(prescriptions, Medications::PrescriptionPresenter),
          treatable: present(current_episode, Medications::TreatablePresenter)
        }
      end

      def redirect_after_successful_save(episode)
        url = patient_pd_peritonitis_episode_path(pd_patient, episode)
        message = success_msg_for("peritonitis episode")
        redirect_to url, notice: message
      end

      def current_episode
        @current_episode ||= begin
          episode = PeritonitisEpisode.for_patient(pd_patient).find(params[:id])
          authorize(episode) if episode.present?
          episode
        end
      end

      def new_episode
        episode = PeritonitisEpisode.for_patient(pd_patient).new
        authorize(episode)
        episode
      end

      def peritonitis_episode_params
        params
          .require(:pd_peritonitis_episode)
          .permit(
            :diagnosis_date, :treatment_start_date, :treatment_end_date,
            :catheter_removed, :line_break, :exit_site_infection,
            :diarrhoea, :abdominal_pain, :fluid_description_id, :white_cell_total,
            :white_cell_neutro, :white_cell_lympho, :white_cell_degen,
            :white_cell_other, :notes, episode_types: []
          )
      end
    end
  end
end
