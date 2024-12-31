module Renalware
  # Usage
  #
  # = render Renalware::ModalComponent.new(remote: true) do |modal|
  #   = modal.trigger do
  #     = link_to t("btn.add"),
  #               new_resource_path(patient),
  #               class: "button",
  #               data: modal.trigger_attributes
  #
  #   = modal.body do

  #
  # in /my_resources/new.html.slim wrap the section that you'd like
  # to go in the modal in {Renalware::ModalBodyComponent} like so:
  # = render Renalware::ModalBodyComponent.new do
  #   / modal content
  #
  class ModalComponent < ApplicationComponent
    include Turbo::FramesHelper
    include Renalware::IconHelper
    attr_reader :remote, :title, :size_css_classes, :turbo_frame_id

    # if changing these, remember to test all instance of ModalComponent
    DEFAULT_SIZE_CSS_CLASSES = "sm:w-full sm:max-w-xl".freeze

    # renders_one :body
    # renders_one :trigger
    # renders_one :bottom_buttons_nav

    def initialize(remote: false, title: nil, size_css_classes: nil, turbo_frame_id: nil)
      @remote = remote
      @title = title
      @size_css_classes = size_css_classes || DEFAULT_SIZE_CSS_CLASSES
      @turbo_frame_id = turbo_frame_id || "modal"
      super
    end

    def trigger_attributes
      { action: "click->modal#open" }
    end
  end
end
