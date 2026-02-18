Before("@web or @legacy") do
  next if ENV["TEST_DEPTH"] == "web"

  raise <<~MSG
    Web cucumber scenarios require TEST_DEPTH=web.
    Run:
      TEST_DEPTH=web bundle exec cucumber -p rake_web features
  MSG
end
