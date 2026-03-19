module Renalware
  Rails.benchmark "Creating Admission::Specialties" do
    %w(Cardiology
       Chest
       Gynaecology
       ITU
       LITU
       Liver
       Medicine
       Neuro
       Obstetrics
       Orthopaedics
       Rheumatology
       Surgery
       Urology
       Other).each do |name|
      Admissions::Specialty.find_or_create_by!(name: name)
    end
  end
end
