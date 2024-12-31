module Renalware
  Rails.benchmark "Adding HD Diurnal Periods" do
    file_path = File.join(File.dirname(__FILE__), "diurnal_period_codes.csv")
    CSV.foreach(file_path, headers: true) do |row|
      code = HD::DiurnalPeriodCode.find_or_initialize_by(code: row["code"]) do |dpcode|
        dpcode.description = row["description"]
        dpcode.sort_order = row["sort_order"]
      end
      code.save!
    end
  end
end
