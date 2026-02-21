module MessageSpecHelper
  # rubocop:disable Metrics/MethodLength
  def create_mesh_letter(patient:, user:, to: :primary_care_physician)
    create_letter(
      state: :approved,
      to:,
      patient:,
      author: user,
      by: user
    ).reload.tap do |letter|
      letter.archive = create(
        :letter_archive,
        letter:,
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
    user || create(:user, :minimal)
    create(
      :letter_patient,
      given_name:,
      practice:,
      primary_care_physician: create(:letter_primary_care_physician, practices: [practice]),
      by: user
    )
  end
end
