SimpleCov.start "rails" do
  use_merging true
  merge_timeout 1200 # 20 minutes
  # This adds a group (tab) to Simplecov's report that only shows coverage for
  # files changes in the current branch. Useful for code reviews.
  add_group 'Changed' do |source_file|
    `git log --oneline --pretty="format:" --name-only main.. | awk 'NF' | sort -u`
      .split("\n").detect do |filename|
        source_file.filename.ends_with?(filename)
      end
  end
end
