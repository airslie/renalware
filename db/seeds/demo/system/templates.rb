module Renalware
  class CreateSystemTemplate
    def self.call(name:, title:, description:)
      Renalware::System::Template.find_or_create_by!(name: name) do |template|
        template.title = title
        template.description = description
        template_path = File.join(File.dirname(__FILE__), "templates", "#{name}.html")
        template.body = File.read(template_path)
      end
    end
  end

  Rails.benchmark "Adding Templates" do
    CreateSystemTemplate.call(
      name: "esi_printable_form",
      title: "ESI Printable Form",
      description: "Renders at /patients/1/pd/exit_site_infections/1.pdf as a PDF form " \
                   "a nurse can print"
    )

    CreateSystemTemplate.call(
      name: "peritonitis_episode_printable_form",
      title: "Peritonitis Episode Printable Form",
      description: "Renders at /patients/1/pd/peritonitis_episodes/1.pdf as a PDF form " \
                   "a nurse can print"
    )
  end
end
