# frozen_string_literal: true

module Renalware
  class InvokeCommandJob < ApplicationJob
    class InvokeCommandJobError < StandardError; end

    def perform(command)
      stdout, stderr, status = Open3.capture3(command)

      puts stdout

      unless status.success?
        raise InvokeCommandJobError,
              "Error executing '#{command}' stderror: '#{stderr} stdout: #{stdout}"
      end
    end
  end
end
