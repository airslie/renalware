# frozen_string_literal: true

module Renalware
  class InvokeCommandJob < ApplicationJob
    class InvokeCommandJobError < StandardError; end

    def perform(command)
      stdin, stdout, stderr, wait_thr = Open3.popen3(command)
      err = stderr.read
      msg = stdout.read

      if err.present?
        raise InvokeCommandJobError, "#{err}; Command: #{command}"
      end

      if msg.present?
        puts msg
      end
    end
  end
end
