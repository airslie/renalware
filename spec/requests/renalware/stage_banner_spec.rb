describe "Renalware stage banner" do
  around do |example|
    original_stage = ENV.fetch("RENALWARE_STAGE", nil)

    example.run
  ensure
    original_stage.nil? ? ENV.delete("RENALWARE_STAGE") : ENV["RENALWARE_STAGE"] = original_stage
  end

  def stage_banner
    Nokogiri::HTML(response.body).at_css(".stage-banner")
  end

  it "renders the banner in uat" do
    ENV["RENALWARE_STAGE"] = "uat"

    get root_path

    expect(response).to be_successful
    expect(stage_banner).to be_present
    expect(stage_banner["class"]).to include("stage-banner--uat")
  end

  it "does not render the banner outside uat" do
    ENV["RENALWARE_STAGE"] = "production"

    get root_path

    expect(response).to be_successful
    expect(stage_banner).to be_nil
  end
end
