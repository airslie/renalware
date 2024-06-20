# frozen_string_literal: true

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
    attr_reader :remote, :title, :size_css_classes

    DEFAULT_SIZE_CSS_CLASSES = "sm:w-full.sm:max-w-xl"

    # renders_one :body
    # renders_one :trigger
    # renders_one :bottom_buttons_nav

    def initialize(remote: false, title: nil, size_css_classes: nil)
      @remote = remote
      @title = title
      @size_css_classes = size_css_classes || DEFAULT_SIZE_CSS_CLASSES

      super
    end

    def trigger_attributes
      { action: "click->modal#open" }
    end
  end
end
