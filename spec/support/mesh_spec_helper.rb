module MeshSpecHelper
  # rubocop:disable Metrics/MethodLength
  def create_mesh_letter(patient:, user:, to: :primary_care_physician)
    create_letter(
      state: :approved,
      to: to,
      patient: patient,
      author: user,
      approved_by: user,
      by: user
    ).reload.tap do |letter|
      letter.archive = create(
        :letter_archive,
        letter: letter,
        by: user,
        content: <<~HTML)
          <div id="main">
            <div id="distribution-list">yes</div>
            <div id="other">no</div>
          </div>
        HTML
    end
  end
  # rubocop:enable Metrics/MethodLength

  def create_mesh_patient(given_name: "John", practice: nil, user: nil)
    practice ||= create(:practice)
    user || create(:user)
    create(
      :letter_patient,
      given_name: given_name,
      practice: practice,
      primary_care_physician: create(:letter_primary_care_physician, practices: [practice]),
      by: user
    )
  end

  def create_mesh_letter_to_gp(patient, user, to: :primary_care_physician)
    create_letter(
      state: :approved,
      to: to,
      patient: patient,
      author: user,
      approved_by: user,
      topic: create(:letter_topic, snomed_document_type: create(:snomed_document_type)),
      by: user
    ).reload.tap do |letter|
      letter.archive = create(:letter_archive, letter: letter, by: user)
    end
  end
end
