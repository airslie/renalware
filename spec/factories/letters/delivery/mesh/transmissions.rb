FactoryBot.define do
  factory(
    :letter_mesh_transmission,
    class: "Renalware::Letters::Transports::Mesh::Transmission"
  ) do
    letter
  end
end
