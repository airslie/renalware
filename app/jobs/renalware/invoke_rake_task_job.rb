# frozen_string_literal: true

module Renalware
  class InvokeRakeTaskJob < ApplicationJob
    def perform(rake_task, *args)
      Rake::Task[rake_task].invoke(*args)
    end
  end
end
