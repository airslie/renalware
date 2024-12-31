# See https://www.stimulus-components.com/docs/stimulus-read-more/ for a better description.
#
# Works with the read-more the controller.
#
# Given some long text, it displays a truncated number of rows (eg 1) and a 'More...' link below it.
# When expanded, the link changes to 'Less...' and will un-expand the text.
# The truncation is controlled by the .line-clamp CSS class.
# Can be improved by allowing the CSS variable --read-more-line-clamp to be set in the ctor.
#
# A failing of this component is that it does not hide the More.. when it is not necessary
# eg if the notes do not span more that
#
# Usage
#   render Renalware::ReadMoreComponent.new("very long string")
module Renalware
  class ReadMoreComponent < ApplicationComponent
    pattr_initialize :content

    def render? = content.present?
  end
end
