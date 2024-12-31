When(/^Clyde records a new snippet$/) do |table|
  hash = table.hashes.first.symbolize_keys
  create_snippet_for(@clyde, hash.symbolize_keys)
end

Given(/^Clyde has these snippets$/) do |table|
  table.hashes.each do |row|
    expect_user_to_have_snippet(@clyde, row.symbolize_keys)
  end
end

Then(/^the snippet is available in Clyde's snippets$/) do
  expect_user_to_have_snippet(@clyde, title: "Title", body: "Body")
end
