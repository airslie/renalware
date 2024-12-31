module XmlSpecHelper
  # Use Ox to dump the pre-rendered Ox marshalled XML into its final format
  # and tidy it up to remove vaguaries that can upset tests.
  def format_xml(raw)
    Ox.dump(raw, indent: -1, skip: :skip_return).tr("\n", " ")
  end
end
