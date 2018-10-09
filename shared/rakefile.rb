# frozen_string_literal: true

RSpec::Core::RakeTask.new(:spec) do |c|
  c.pattern = "{/**/}spec/**/*_spec.rb"
end

task default: :spec
