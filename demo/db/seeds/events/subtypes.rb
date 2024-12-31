module Renalware
  Rails.benchmark "Adding Event Subtypes" do
    type = Renalware::Events::Type.find_by!(name: "Dental Study")

    type.subtypes.create!(
      name: "Baseline",
      description: "Initial data",
      position: 0,
      by: Renalware::User.first,
      definition: [
        { date1: { label: "Last seen by dentist (if known)" } },
        { number1: { label: "Number of cavities needing filling" } },
        { number2: { label: "Severity of gingivitis (Grade 1-5)" } },
        { number3: { label: "Number of missing teeth" } },
        { text1: { label: "Has Dentist (Yes / No)" } },
        { text2: { label: "Brushes teeth x2/d (Y/N)" } },
        { text3: { label: "Flosses at least daily (Y/N)" } },
        { text4: { label: "Mouthwash at least daily (Y/N)" } },
        { text5: { label: "Other comments" } }
      ]
    )

    type.subtypes.create!(
      name: "Penultimate",
      description: "Penultimate",
      position: 1,
      by: Renalware::User.first,
      definition: [
        { date1: { label: "Last seen by dentist (if known)" } },
        { number1: { label: "Number of cavities needing filling" } },
        { number2: { label: "Severity of gingivitis (Grade 1-5)" } },
        { number3: { label: "Number of missing teeth" } },
        { text1: { label: "Has Dentist (Yes / No)" } },
        { text2: { label: "Brushes teeth x2/d (Y/N)" } },
        { text3: { label: "Flosses at least daily (Y/N)" } },
        { text4: { label: "Mouthwash at least daily (Y/N)" } },
        { text5: { label: "Other comments" } }
      ]
    )

    type.subtypes.create!(
      name: "Ultimate",
      description: "Ultimate",
      by: Renalware::User.first,
      definition: [
        { date1: { label: "Date recorded" } },
        { number1: { label: "Rate researcher's bed-side manner from 1 (poor) to 10 (excellent)" } }
      ]
    )

    type = Renalware::Events::Type.find_by!(name: "Foot Study")

    type.subtypes.create!(
      name: "Baseline",
      description: "Feet and where to find them",
      by: Renalware::User.first,
      definition: [
        { date1: { label: "Last seen by podiatrist (if known)" } },
        { number2: { label: "Severity of athletes foot (Grade 1-5)" } },
        { number3: { label: "Number of missing toes" } },
        { text1: { label: "Has bunions (Y/N)" } },
        { text5: { label: "Other comments" } }
      ]
    )
  end
end
