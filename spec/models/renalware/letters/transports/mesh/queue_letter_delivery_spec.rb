module Renalware
  describe Letters::Transports::Mesh::QueueLetterDelivery do
    include LettersSpecHelper
    include MeshSpecHelper

    let(:user) { create(:user, :minimal) }
    let(:patient) { create_mesh_patient(user:) }
    let(:approved_letter) { create_mesh_letter_to_gp(patient, user) }
    let(:mesh_send_jobs) do
      lambda do
        ActiveJob::Base.queue_adapter.enqueued_jobs.select do |job|
          job[:job] == Renalware::Letters::Transports::Mesh::SendMessageJob ||
            job["job_class"] == "Renalware::Letters::Transports::Mesh::SendMessageJob"
        end
      end
    end

    before do
      ActiveJob::Base.queue_adapter = :test
      ActiveJob::Base.queue_adapter.enqueued_jobs.clear
      allow(Renalware.config).to receive(:send_gp_letters_over_mesh).and_return(true)
    end

    it "creates a transmission and enqueues a mesh send job immediately by default" do
      allow(Renalware.config)
        .to receive(:mesh_delay_seconds_between_letter_approval_and_mesh_send)
        .and_return(15.minutes)

      expect {
        described_class.call(letter: approved_letter)
      }.to change(Renalware::Letters::Transports::Mesh::Transmission, :count).by(1)
        .and change { mesh_send_jobs.call.count }.by(1)

      transmission = Renalware::Letters::Transports::Mesh::Transmission.last
      enqueued_job = mesh_send_jobs.call.last

      expect(transmission.letter).to eq(Renalware::Letters::Letter.find(approved_letter.id))
      expect(transmission.active_job_id).to be_present
      expect(enqueued_job[:job]).to eq(Renalware::Letters::Transports::Mesh::SendMessageJob)
      expect(enqueued_job[:at]).to be_present
    end

    it "registers the enqueue work for after commit when a callback registrar is provided" do
      callback = nil
      register_after_commit = lambda do |&block|
        callback = block
      end

      expect {
        described_class.call(letter: approved_letter, register_after_commit:)
      }.to change(Renalware::Letters::Transports::Mesh::Transmission, :count).by(1)
        .and not_change { mesh_send_jobs.call.count }

      transmission = Renalware::Letters::Transports::Mesh::Transmission.last

      expect(callback).to be_present
      expect(transmission.active_job_id).to be_nil

      expect {
        callback.call
      }.to change { mesh_send_jobs.call.count }.by(1)
        .and change { transmission.reload.active_job_id.present? }.from(false).to(true)
    end

    it "does not create a transmission when the patient is confidentiality restricted" do
      patient.update_column(:confidentiality, :restricted)

      expect {
        described_class.call(letter: approved_letter)
      }.not_to change(Renalware::Letters::Transports::Mesh::Transmission, :count)

      expect(mesh_send_jobs.call).to be_empty
    end

    it "does not create a transmission when the gp is not a recipient" do
      approved_letter = create_mesh_letter(patient:, user:, to: :patient)

      expect {
        described_class.call(letter: approved_letter)
      }.not_to change(Renalware::Letters::Transports::Mesh::Transmission, :count)

      expect(mesh_send_jobs.call).to be_empty
    end
  end
end
