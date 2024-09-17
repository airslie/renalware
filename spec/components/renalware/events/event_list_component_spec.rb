# frozen_string_literal: true

describe Renalware::Events::EventListComponent, type: :component do
  it "can be created" do
    described_class.new(patient: nil, event_class: nil)
  end
end
