namespace :foundation do
  desc "Print a machine-readable Foundation usage inventory"
  task :audit do
    sh "bin/foundation_audit"
  end

  desc "Write/update baseline Foundation usage inventory"
  task :baseline do
    sh "bin/foundation_audit --write-baseline"
  end

  desc "Fail if Foundation usage exceeds baseline"
  task :guard do
    sh "bin/foundation_audit --guard"
  end
end
