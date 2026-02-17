# frozen_string_literal: true

# Optional: per-worktree runtime dirs to prevent collisions when running multiple worktrees.
# Set WORKTREE_VAR in your shell (direnv) to something like "$PWD/var".
worktree_var = ENV["WORKTREE_VAR"].presence || Rails.root.join("var").to_s

Rails.application.configure do
  # tmp/ and log/ are the big ones
  config.paths["tmp"] = ["#{worktree_var}/tmp"]
  config.paths["log"] = ["#{worktree_var}/log"]
end
