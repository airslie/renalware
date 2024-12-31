module HTMLHelpers
  def html_table_to_array(dom_id)
    find_by_id(dom_id)
      .all("tr")
      .map do |row|
        row.all("th, td").map { |cell| cell.text.strip }
      end
  end

  def html_list_to_array(dom_id)
    find_by_id(dom_id).all("li").map { |cell| cell.text.strip }
  end
end

World(HTMLHelpers)
