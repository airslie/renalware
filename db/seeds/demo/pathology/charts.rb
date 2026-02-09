module Renalware
  class ChartSeeder
    def create_chart_with(title, scope, *obxcodes)
      Pathology::Charts::Chart.find_or_create_by!(title: title, scope: scope).tap do |chart|
        obxcodes.each do |obx|
          chart.observation_descriptions << Pathology::ObservationDescription.find_by!(code: obx)
        end
      end
    end
  end

  Rails.benchmark "Adding Pathology Charts" do
    seeder = ChartSeeder.new
    seeder.create_chart_with("HGB", "perspectives/anaemia", "HGB")
    seeder.create_chart_with("Ferritin", "perspectives/anaemia", "FER")
    seeder.create_chart_with("CRP", "perspectives/anaemia", "CRP")
    seeder.create_chart_with("PTHI", "perspectives/bone", "PTHI")
    seeder.create_chart_with("CAL PHOS", "perspectives/bone", "CAL", "PHOS", "PRODUCT CA PHOS")
  end
end
