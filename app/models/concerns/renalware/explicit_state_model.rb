module Renalware
  # Enables Explicit State Models with ActiveRecord in contrast to the State pattern or
  # Finite State Machines (FSM). For more information:
  # https://medium.com/@martinezdelariva/explicit-state-modeling-f6e534c33508#.ljvhnkz01
  #
  # Example
  #   class Letter < ActiveRecord
  #     include ExplicitStateModel
  #     # define the states you would like
  #     has_states :draft, :approved
  #   end
  #
  # Calling the `has_states` macro will:
  # - define scopes for each state; e.g. `Letter.draft`, `Letter.approved`
  # - add a state attribute; e.g. `Letter::Draft.state # => "draft"`
  #
  # Create subclasses representing those states, this uses ActiveRecord's STI
  # implementation.
  #
  #   class Letter::Draft < Letter
  #     def approve!
  #       becomes!(Approved)
  #     end
  #   end
  #
  #   class Letter::Approved < Letter
  #   end
  #
  # You are responsible for managing state transitions using ActiveRecord's
  # `becomes` class method:
  #
  #   Letter::Draft.create!
  #   draft_letter = Letter.draft.first!
  #   draft_letter.state # => "draft"
  #   draft_letter.draft? # => true
  #   approved_letter = draft_letter.approve!
  #   approved_letter.save!
  #   approved_letter.state # => "approved"
  #
  module ExplicitStateModel
    extend ActiveSupport::Concern

    included do
      # Adds a `state` attribute; e.g. `Letter::Draft.state # => "Draft"`
      #
      def state
        self.class.name.demodulize.underscore
      end
    end

    module ClassMethods
      # Adds a ActiveRecord scopes for each state defined; e.g. `Letter.draft`
      def has_states(*states)
        states.each do |state|
          state_scope(state, state)

          define_method "#{state}?" do
            send(:state) == state.to_s
          end
        end

        define_singleton_method :states do
          states
        end
      end

      # Allows for custom scope names, example:
      #
      #   class Letter
      #     has_states :draft, :approved
      #     state_scope :reviewable, :draft
      #   end
      #
      #   Letter.reviewable # => returns draft letters
      #
      def state_scope(name, state)
        instance_eval do
          scope name, -> { where(type: state_class_name(state)) }
        end
      end

      def state_class_name(name)
        const_get(name.to_s.classify).to_s
      end
    end
  end
end
