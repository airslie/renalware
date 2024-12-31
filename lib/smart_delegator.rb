# This class delegates method calls to the given object.
# If the returned value is an instance of the original object,
# the smart delegator will return a new instance of itself with
# the original object.
#
# This is in contrast to SimpleDelegator which will return the
# original object.
#
# The chart below demonstrates the difference:
#
#    `mymessage` ->
#       SimpleDelegator ->
#         OriginalObject ->
#           invokes `mymessage` returning self ->
#             returns OriginalObject
#    `mymessage` ->
#       SmartDelegator  ->
#         OriginalObject ->
#           invokes `mymessage` returning self ->
#             returns SmartDelegator decorating OriginalObject
class SmartDelegator
  attr_reader :object

  def initialize(object)
    @object = object
  end

  def respond_to?(method, include_private = false)
    super || object.respond_to?(method, include_private)
  end

  def inspect
    "SmartDelegator(#{object.inspect})"
  end

  def method_missing(method, *, &)
    returned_object = object.public_send(method, *, &)
    if returned_object.instance_of?(object.class)
      self.class.new(returned_object)
    else
      returned_object
    end
  end
end
