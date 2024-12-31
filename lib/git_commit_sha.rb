class GitCommitSha
  def self.current
    new.current
  end

  def current
    return git_sha if Rails.env.development?

    capistrano_sha || heroku_sha
  end

  private

  def git_sha
    `git rev-parse HEAD`[0...6]
  end

  def heroku_sha
    ENV.fetch("SOURCE_VERSION", nil)
  end

  def capistrano_sha
    sha_from_file("REVISION")
  end

  def sha_from_file(filename)
    file = Rails.root.join(filename)
    File.exist?(file) && File.open(file, &:gets)
  end
end
