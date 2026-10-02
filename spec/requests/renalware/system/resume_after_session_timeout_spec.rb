describe "Resuming where you left off after a session timeout" do
  let(:user) { create(:user, :clinical) }
  let(:other_user) { create(:user, :clinical) }
  let(:memory) { Renalware.config.duration_of_last_url_memory_after_session_expiry }

  before do
    Warden.test_reset!
    create(:role, :clinical)
  end

  def sign_in_with_password(as)
    post user_session_path, params: { user: { username: as.username, password: as.password } }
  end

  def time_out_while_on(path, after: Devise.timeout_in + 1.minute)
    travel(after)
    get path
    expect(flash[:timedout]).to be(true)
    follow_redirect!
    expect(response).to redirect_to(new_user_session_path)
  end

  it "returns the user to the page they were on" do
    sign_in_with_password(user)
    get root_path

    time_out_while_on "/patients/1/hd/sessions?page=2"
    sign_in_with_password(user)

    expect(response).to redirect_to("/patients/1/hd/sessions?page=2")
  end

  it "returns the user to the page they were on even when they had been signed in for hours" do
    sign_in_with_password(user)
    12.times do
      travel 15.minutes
      get root_path
    end

    time_out_while_on "/patients/1"
    sign_in_with_password(user)

    expect(response).to redirect_to("/patients/1")
  end

  it "returns the user to the record they were editing rather than the form" do
    sign_in_with_password(user)
    get root_path

    time_out_while_on "/patients/1/hd/sessions/5/edit"
    sign_in_with_password(user)

    expect(response).to redirect_to("/patients/1/hd/sessions/5")
  end

  it "sends a different user who signs in on the same browser to their dashboard" do
    sign_in_with_password(user)
    get root_path

    time_out_while_on "/patients/1"
    sign_in_with_password(other_user)

    expect(response).to redirect_to(root_path)
  end

  it "sends the user to their dashboard when they sign in long after their session expired" do
    sign_in_with_password(user)
    get root_path

    time_out_while_on "/patients/1", after: Devise.timeout_in + memory + 1.minute
    sign_in_with_password(user)

    expect(response).to redirect_to(root_path)
  end

  it "measures the memory period from when the session expired, not when it was noticed" do
    sign_in_with_password(user)
    get root_path

    time_out_while_on "/patients/1", after: Devise.timeout_in + memory - 1.minute
    sign_in_with_password(user)

    expect(response).to redirect_to("/patients/1")
  end

  it "returns the user to the patient rather than an unsaved transplant workup form" do
    patient = create(:transplant_patient)
    sign_in_with_password(user)
    get root_path

    time_out_while_on "/patients/#{patient.to_param}/transplants/donor/workup/edit"
    sign_in_with_password(user)

    expect(response).to redirect_to("/patients/#{patient.to_param}")
    follow_redirect!
    expect(response).to be_successful
  end

  it "sends the user to their dashboard when the form they were on has no page to return to" do
    sign_in_with_password(user)
    get root_path

    time_out_while_on "/system/view_metadata/1/edit"
    sign_in_with_password(user)

    expect(response).to redirect_to(root_path)
  end

  describe "a page served by a mounted engine" do
    it "returns the user to the page they were on" do
      sign_in_with_password(user)
      get root_path

      time_out_while_on "/research/studies"
      sign_in_with_password(user)

      expect(response).to redirect_to("/research/studies")
    end

    it "sends a different user to their dashboard" do
      sign_in_with_password(user)
      get root_path

      time_out_while_on "/research/studies"
      sign_in_with_password(other_user)

      expect(response).to redirect_to(root_path)
    end
  end

  describe "when the session times out during a background keep-alive request" do
    def time_out_during_keep_alive_then_reload(path)
      travel(Devise.timeout_in + 1.minute)
      get keep_session_alive_path, xhr: true, as: :json
      expect(response).to have_http_status(:unauthorized)
      get path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "returns the user to the page that was reloaded" do
      sign_in_with_password(user)
      get root_path

      time_out_during_keep_alive_then_reload "/patients/1/edit"
      sign_in_with_password(user)

      expect(response).to redirect_to("/patients/1")
    end

    it "sends a different user to their dashboard" do
      sign_in_with_password(user)
      get root_path

      time_out_during_keep_alive_then_reload "/patients/1/edit"
      sign_in_with_password(other_user)

      expect(response).to redirect_to(root_path)
    end
  end

  describe "when the session times out on submitting a form" do
    let(:form_url) { "http://www.example.com/patients/1/hd/sessions/5/edit" }

    def time_out_submitting_form
      travel(Devise.timeout_in + 1.minute)
      patch "/patients/1/hd/sessions/5", headers: { "HTTP_REFERER" => form_url }
      expect(response).to redirect_to(form_url)
      follow_redirect!
      expect(response).to redirect_to(new_user_session_path)
    end

    it "returns the user to the record they were editing rather than the form" do
      sign_in_with_password(user)
      get root_path

      time_out_submitting_form
      sign_in_with_password(user)

      expect(response).to redirect_to("/patients/1/hd/sessions/5")
    end

    it "sends a different user to their dashboard" do
      sign_in_with_password(user)
      get root_path

      time_out_submitting_form
      sign_in_with_password(other_user)

      expect(response).to redirect_to(root_path)
    end
  end

  it "still takes a signed-out visitor to the page they asked for after signing in" do
    get "/patients/1"
    expect(response).to redirect_to(new_user_session_path)

    sign_in_with_password(user)

    expect(response).to redirect_to("/patients/1")
  end

  describe "signing back in with Microsoft Entra ID" do
    around do |example|
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:entra_id] = OmniAuth::AuthHash.new(provider: "entra_id", uid: "x")
      example.run
    ensure
      OmniAuth.config.mock_auth.delete(:entra_id)
      OmniAuth.config.test_mode = false
    end

    def sign_in_with_entra(as)
      allow(Renalware::User).to receive(:from_entra_id_omniauth).and_return(as)
      post user_entra_id_omniauth_authorize_path
      follow_redirect!
    end

    it "returns the user to the page they were on" do
      sign_in_with_entra(user)
      get root_path

      time_out_while_on "/patients/1"
      sign_in_with_entra(user)

      expect(response).to redirect_to("/patients/1")
    end

    it "sends a different user to their dashboard" do
      sign_in_with_entra(user)
      get root_path

      time_out_while_on "/patients/1"
      sign_in_with_entra(other_user)

      expect(response).to redirect_to(root_path)
    end

    it "sends the user to their dashboard when they sign in long after their session expired" do
      sign_in_with_entra(user)
      get root_path

      time_out_while_on "/patients/1", after: Devise.timeout_in + memory + 1.minute
      sign_in_with_entra(user)

      expect(response).to redirect_to(root_path)
    end
  end
end
