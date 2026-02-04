json.id page.id
json.route page.route
json.annotations do
  page.annotations.each do |annotation|
    json.child! do
      json.id annotation.id
      json.title annotation.title
      json.text annotation.text
      json.attachTo do
        json.element annotation.attached_to_selector
        json.on annotation.attached_to_position
      end
    end
  end
end
