Given(/^Patty is being treated for a peritonitis episode$/) do
  record_peritonitis_episode_for(
    patient: @patty,
    user: @clyde,
    diagnosed_on: "10-10-2016"
  )

  record_organism_for(
    infectable: episode_for(@patty),
    organism_name: "Staphylococcus aureus"
  )
end

Given(/^Clyde recorded a peritonitis episode for Patty$/) do
  record_peritonitis_episode_for(
    patient: @patty,
    user: @clyde,
    diagnosed_on: "10-10-2016"
  )
end

Given(/^recorded the organism for the episode$/) do
  record_organism_for(
    infectable: episode_for(@patty),
    organism_name: "Staphylococcus aureus"
  )
end

When(/^Clyde records a peritonitis episode for Patty$/) do
  record_peritonitis_episode_for(
    patient: @patty,
    user: @clyde,
    diagnosed_on: "10-10-2016"
  )
end

When(/^records the organism for the episode$/) do
  record_organism_for(
    infectable: episode_for(@patty),
    organism_name: "Staphylococcus aureus"
  )
end

Then(/^a peritonitis episode is recorded for Patty$/) do
  expect_peritonitis_episode_to_be_recorded(patient: @patty)
end

Then(/^Clyde can revise the peritonitis episode$/) do
  revise_peritonitis_episode_for(
    patient: @patty,
    user: @clyde,
    diagnosed_on: "11-11-2015"
  )

  revise_organism_for(
    infectable: episode_for(@patty),
    sensitivity: "Lorem ipsum.",
    resistance: "tetracycline"
  )

  expect_peritonitis_episodes_revisions_recorded(patient: @patty)
end

Then(/^Clyde can terminate the organism for the episode$/) do
  terminate_organism_for(
    infectable: episode_for(@patty),
    user: @clyde
  )
end
