# Used in app/models/renalware/ukrdc/outgoing/rendering/clinic_visit_observation.rb:11
class DumbDelegator < BasicObject
  # Handle public_send correctly when ActionView calls this method
  # Reference: https://github.com/stevenharman/dumb_delegator/issues/9
  #
  def public_send(method, *, &)
    if respond_to?(method)
      __send__(method, *, &)
    else
      __getobj__.public_send(method, *, &)
    end
  end

  def try(*_a, &)
    raise "Cannot call #try on a BasicObject"
  end

  def try!(*_a, &)
    raise "Cannot call #try! on a BasicObject"
  end

  def send(method_name, *, &)
    __send__(method_name, *, &)
  end

  def inspect
    "DumbDelegator(#{__getobj__.inspect})"
  end
end
