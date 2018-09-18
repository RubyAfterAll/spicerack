# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

require_relative "shared/rakefile"

SPICERACK_GEMS = %w[around_the_world].freeze

version = File.read("#{__dir__}/SPICERACK_VERSION").strip

%w[spicerack] + SPICERACK_GEMS.each do |gem|
  namespace gem do
    task :update_version do
      file_prefix = (gem == "spicerack") ? "" : "#{__dir__}/#{gem}/"
      file_path = "#{file_prefix}lib/#{gem}/version.rb"
      file_text = File.read(file_path)

      file_text.gsub!(%r{^(\s*)VERSION(\s*)= .*?$}, "\\1VERSION = \"#{version}\"")
      raise StandardError, "Could not insert VERSION in #{file_path}" unless $1

      File.open(file_path, "w") { |f| f.write file_text }
    end
  end
end

namespace :spicerack do
  task :update_all_versions do
    SPICERACK_GEMS.each { |gem| Rake::Task["#{gem}:update_version"].invoke }
  end

  task :release_all do
    Rake::Task["release"].invoke
    SPICERACK_GEMS.each { |gem| sh "cd #{gem} && bundle exec rake release" }
  end
end
