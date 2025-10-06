SimpleCov.start "rails" do
  use_merging true
  merge_timeout 1200 # 20 minutes

  # Enable branch coverage tracking
  enable_coverage :branch

  # Additional filters beyond the default rails profile
  add_filter "/bin/"
  add_filter "/demo/"
  add_filter "/spec/"
  add_filter "/features/"
  add_filter "/vendor/"
  add_filter "/rubocop/"
  add_filter "/.devbox/"

  # Groups for better organization in the HTML report
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Services", "app/services"
  add_group "Jobs", "app/jobs"
  add_group "Mailers", "app/mailers"
  add_group "Helpers", "app/helpers"
  add_group "Views", "app/views"
  add_group "Components", ["app/components", "app/view_components"]
  add_group "Libraries", "lib"

  # This adds a group (tab) to Simplecov's report that only shows coverage for
  # files changes in the current branch. Useful for code reviews.
  add_group 'Changed' do |source_file|
    # Determine base branch (try main, then origin/main for CI environments)
    base_branch = `git rev-parse --verify main 2>/dev/null`.strip.empty? ? 'origin/main' : 'main'

    changed_files = `git log --oneline --pretty="format:" --name-only \
      #{base_branch}.. 2>/dev/null | awk 'NF' | sort -u`
    changed_files.split("\n").detect do |filename|
      source_file.filename.ends_with?(filename)
    end
  end
end
