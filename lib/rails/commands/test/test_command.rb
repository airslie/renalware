# frozen_string_literal: true

require "English"

module Rails
  module Command
    class TestCommand < Base
      CI_TEST_COMMANDS = %w(
        bin/gh/rspec/unit
        bin/gh/rspec/integration
        bin/gh/cucumber/domain
        bin/gh/cucumber/web
      ).freeze

      desc "test", "Run the same test suites as CI"
      def perform(*args)
        validate_args!(args)
        run_ci_suite
      end

      desc "all", "Run the same test suites as CI"
      def all(*args)
        validate_args!(args)
        run_ci_suite
      end

      private

      def validate_args!(args)
        return if args.empty?

        raise Thor::Error,
              "bin/rails test does not support path filtering here. " \
              "Use the bin/gh/* scripts directly."
      end

      def run_ci_suite
        root = Pathname.new(File.expand_path("../../../..", __dir__))

        CI_TEST_COMMANDS.each do |command|
          say "Running #{command}"

          next if system(root.join(command).to_s, chdir: root.to_s)

          raise SystemExit, ($CHILD_STATUS&.exitstatus || 1)
        end
      end
    end
  end
end
