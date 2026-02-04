describe "Rendering guide/help JSON for a Help::Tours::Page" do
  describe "GET show" do
    context "when a help tour for the page is not found" do
      it "responds with empty JSON" do
        get help.tours_page_path(id: "foo")

        expect(response).to be_successful
        expect(response.content_type).to match("application/json")
        expect(response.body).to eq("{}")
      end
    end

    context "when a help tour for the page is found" do
      it "responds with JSON" do # rubocop:disable RSpec/ExampleLength
        foo_page = Renalware::Help::Tours::Page.create!(route: "foo")
        annotation3 = foo_page.annotations.create!(
          title: "Title3",
          text: "Text3",
          attached_to_selector: "selector3",
          position: 3
        )
        annotation1 = foo_page.annotations.create!(
          title: "Title1",
          text: "Text1",
          attached_to_selector: "selector1",
          position: 1
        )

        get help.tours_page_path(id: "foo", format: :json)

        expect(response).to be_successful
        expect(response.content_type).to match("application/json")

        expected_json = {
          id: foo_page.id,
          route: "foo",
          annotations: [
            {
              id: annotation1.id,
              title: "Title1",
              text: "Text1",
              attachTo: {
                element: "selector1",
                on: annotation1.attached_to_position
              }
            },
            {
              id: annotation3.id,
              title: "Title3",
              text: "Text3",
              attachTo: {
                element: "selector3",
                on: annotation3.attached_to_position
              }
            }
          ]
        }.as_json

        expect(response.parsed_body).to eq(expected_json)
      end
    end
  end
end
