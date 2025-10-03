module Renalware::ComponentHelper
  def render_toggled_cell(record)
    render Renalware::NameService
      .from_model(record, to: "Detail")
      .new(record)
  end
end
