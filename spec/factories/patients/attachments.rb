FactoryBot.define do
  factory :patient_attachment, class: "Renalware::Patients::Attachment" do
    accountable
    patient
    attachment_type factory: %i(patient_attachment_type)
    name { Faker::File.file_name }
    description { Faker::Lorem.sentence }
    document_date { Faker::Date.between(from: 1.year.ago, to: Time.zone.today) }
    file do
      Rack::Test::UploadedFile.new(
        Rails.root.join("spec/fixtures/files/cat.png")
      )
    end
  end
end
