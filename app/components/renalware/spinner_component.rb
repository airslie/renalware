module Renalware
  # A spinner component that can be used with a turbo frame (for example) to show a spinner while
  # a turboframe is 'busy'.
  #
  # Example usage:
  # slim:
  #   = turbo_frame_tag "mydiv" do
  #     = render Renalware::SpinnerComponent.new do |spinner|
  #       = spinner.with_pre_content do
  #         / content above the spinner/main content that does not change. A title etc?
  #       = spinner.with_main_content do
  #        / content here will be overlaid with a spinner svg during a turboframe busy event
  #        / for any frame wrapping SpinnerComponent
  #
  # Currently you need to add this css for each use case:
  #   css:
  #     turbo-frame#mydiv {
  #       .loading-element {
  #         visibility: hidden;
  #       }
  #     }
  #
  #     turbo-frame[busy]#mydiv {
  #       .loading-element {
  #         visibility: initial;
  #       }
  #     }
  #
  class SpinnerComponent < ApplicationComponent
    renders_one :pre_content
    renders_one :main_content
  end
end
