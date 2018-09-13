require "bundler/gem_tasks"

REPO_GEMS = %w[around_the_world]

task default: :spec

desc "Run spec task for all projects"
task :spec do
  errors = []
  REPO_GEMS.each do |repo_gem|
    system(%(cd #{repo_gem} && #{$0} spec)) || errors << repo_gem
  end
  fail("Errors in #{errors.join(', ')}") unless errors.empty?
end
