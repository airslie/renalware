module RansackHelper
  def sort_link_if(condition, query, attribute, label, *)
    if condition
      sort_link([:renalware, query], attribute, label, *)
    else
      label
    end
  end
end
