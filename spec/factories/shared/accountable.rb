# A global trait for setting created_by and updated_by.
#
# When a model includes the Accountable concern, it adds a #by attributes and this
# can be set as a shorthand for setting both created_by and updated_by.
# Similarly, any factory defined against such a model therefore naturally has a by
# attribute available, so we can for example do
#
#    create(:patient, by: user_a)
#
# which is equivalent to
#
#    create(:patient, created_by: user_a, updated_by: user_a)
#
# However if you don't call `create` with a `by` or `*_by` arguments, the default `association` we
# define here in this global trait ensures only one user - accountable_actor is created and assigned
# to both created_by and updated_by. Previously each had its own `user` association and two users
# were created each time any model (that included Accountable) was created by FactoryBot.
# If you need to use the same user for any other attribute in a factory, you can do for instance
#
#     factory :audit do
#       accountable
#       requested_by { accountable_actor }
#     end
#
#  Which create one user and assign them to updated_by, createed_by and requested_by.
#
FactoryBot.define do
  trait :accountable do
    transient do
      accountable_actor { by || create(:user) }
    end
    created_by { accountable_actor }
    updated_by { accountable_actor }
  end
end
