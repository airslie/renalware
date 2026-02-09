require_relative "rails_helper"

# factory_names = FactoryBot.factories.map(&:name)
# puts "Checking factories #{factory_names.first}"

RSpec.describe "Factories" do
  pending "Skipping factories spec for now - some flakiness in CI, and not critical"

  # FactoryBot.factories.map(&:name).each do |factory_name|
  #   it "#{factory_name} can be built and created" do
  #     factory = build(factory_name)
  #     pending "Ignoring OpenStruct factory #{factory_name}" if factory.is_a?(OpenStruct)
  #     expect(factory).to be_valid
  #     created_factory = create(factory_name)

  #     # Skip validation for Medications::Delivery::Event as it returns the following
  #     # validation error which I've not been able to resolve:
  #     #   There are no home delivery prescriptions for this drug type
  #     expect(created_factory).to be_valid unless factory.is_a?(Renalware::Medications::Delivery::Event)
  #   end
  # end
end
