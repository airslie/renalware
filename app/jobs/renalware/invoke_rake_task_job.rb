# frozen_string_literal: true

require "rake"

module Renalware
  class InvokeRakeTaskJob < ApplicationJob
    def perform(rake_task, *args)
      Rails.application.load_tasks
      Rake::Task[rake_task].invoke(*args)
    end
  end
end
