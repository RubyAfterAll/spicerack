# frozen_string_literal: true

require_relative "../shared/spec_helper"
require "spicery"
require "pry"

root_directory = File.expand_path('../', File.dirname(__FILE__))
Dir["#{root_directory}/**/spec/support/**/*.rb"].reject { |path| path.include? "vendor" }.each { |f| require f }
