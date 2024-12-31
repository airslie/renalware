FactoryBot.define do
  factory :patient_attachment_type, class: "Renalware::Patients::AttachmentType" do
    name { "FileType #{SecureRandom.hex(8)}" }
    store_file_externally { false }
  end
end
