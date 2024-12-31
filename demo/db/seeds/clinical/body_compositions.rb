module Renalware
  Rails.benchmark "Adding Body Composition Measurements for Roger RABBIT" do
    class CreateBodyComposition
      def initialize
        @rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Roger")
        @user_id = Renalware::User.last.id
      end

      def call(on: Time.zone.now - 2.weeks,
               notes: "Lorem ipusm")
        Clinical::BodyComposition.new(
          patient_id: @rabbit.id,
          modality_description: Modalities::Description.find(3),
          notes: Faker::Lorem.sentence,
          assessed_on: on,
          created_by_id: @user_id,
          updated_by_id: @user_id,
          assessor_id: @user_id,
          overhydration: rand(-20..20).round(1),
          volume_of_distribution: rand(50.0..90.0).round(1),
          total_body_water: rand(50.0..70.0).round(1),
          extracellular_water: rand(30.0..50.0).round(1),
          intracellular_water: rand(20.0..40.0).round(1),
          lean_tissue_index: rand(50.0..70.0).round(1),
          fat_tissue_index: rand(50.0..70.0).round(1),
          lean_tissue_mass: rand(50.0..70.0).round(1),
          fat_tissue_mass: rand(50.0..70.0).round(1),
          adipose_tissue_mass: rand(50.0..70.0).round(1),
          body_cell_mass: rand(50.0..70.0).round(1),
          quality_of_reading: rand(50.000..100.000).round(3)
        ).save!
      end
    end

    CreateBodyComposition.new.call(on: Time.zone.now - 2.months)
    CreateBodyComposition.new.call(on: Time.zone.now - 1.month)
    CreateBodyComposition.new.call(on: Time.zone.now - 1.week)
  end
end
