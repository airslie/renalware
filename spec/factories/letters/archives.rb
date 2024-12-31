FactoryBot.define do
  factory :letter_archive, class: "Renalware::Letters::Archive" do
    uuid { SecureRandom.uuid }
    pdf_content { "%PDF-1.3" }
    content {
      <<-HTML
        <div id="main">
          <div id="toc-distribution-list"/>
          <div id="toc-problem-list"/>
          <div id="toc-medications-and-medical_devices"/>
          <div id="toc-investigation-results"/>
          <div id="toc-author"/>
          <div id="other"/>
        </div>
      HTML
    }
  end
end
