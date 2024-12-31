module Renalware
  module ClipboardHelper
    # A helper to create a clipboard.js button https://clipboardjs.com/
    def clipboard_button_for(target, width: "13rem")
      tag.button data: { "clipboard-action" => "copy", "clipboard-target" => target },
                 class: "button compact low-key clipboard-btn" do
        image_tag "renalware/clippy.svg", width: width
      end
    end
  end
end
