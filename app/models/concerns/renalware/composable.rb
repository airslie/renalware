# frozen_string_literal: true

module Renalware
  # When included, a class (or instance of a class) that has a #call method can be composed
  # with other simlar classes or with procs using the Proc compose operators << >>
  # https://ruby-doc.org/core-3.0.2/Proc.html#method-i-3C-3C
  # https://www.alchemists.io/articles/ruby_function_composition
  module Composable
    extend ActiveSupport::Concern

    def >>(other) = method(:call) >> other
    def <<(other) = method(:call) << other
    def call = fail(NotImplementedError, "`#{self.class.name}##{__method__}` not implemented.")
  end
end
