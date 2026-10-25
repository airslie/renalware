describe Renalware::EPR::EventListener do
  include_context "with DVH as the EPR site"

  let(:patient) { create(:patient, local_patient_id_3: "345") }
  let(:event) { create(:simple_event, patient:) }
  let(:filename) { "an_event.pdf" }

  before do
    allow(Renalware.config).to receive(:epr_events_folder).and_return("/var/epr/events")
    ActiveJob::Base.queue_adapter = :test
    allow(Renalware::EPR::MdtFilename).to receive(:new)
      .and_return(instance_double(Renalware::EPR::MdtFilename, to_s: filename))
    event.event_type.update!(save_pdf_to_electronic_public_register: true)
  end

  it "saves the event to the tmp folder" do
    expect { described_class.new.event_created(event) }
      .to have_enqueued_job(Renalware::EPR::SaveEventJob)
      .on_queue("pdf_generation")
      .with(event:, file_path: "/var/epr/events/tmp/#{filename}")
  end

  it "saves the event to the archive folder" do
    expect { described_class.new.event_created(event) }
      .to have_enqueued_job(Renalware::EPR::SaveEventJob)
      .with(event:, file_path: "/var/epr/events/archive/#{filename}")
  end

  it "does nothing for a patient who is not at the site" do
    event.patient.update_columns(local_patient_id_3: nil)

    expect { described_class.new.event_created(event.reload) }
      .not_to have_enqueued_job(Renalware::EPR::SaveEventJob)
  end

  it "does nothing when the event type is not saved to the EPR" do
    event.event_type.update!(save_pdf_to_electronic_public_register: false)

    expect { described_class.new.event_created(event) }
      .not_to have_enqueued_job(Renalware::EPR::SaveEventJob)
  end
end
