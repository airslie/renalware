module Renalware
  Rails.benchmark "Adding tours help" do
    page = Help::Tours::Page.create!(route: "/dashboard")
    Help::Tours::Annotation.create!(
      page: page,
      position: 1,
      title: "Test1 title",
      text: "Test1 body",
      attached_to_position: "bottom",
      attached_to_selector: "body"
    )
  end
end
