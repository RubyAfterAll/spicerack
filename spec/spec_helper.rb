# frozen_string_literal: true

require_relative "../shared/spec_helper"
require "spicerack"
require "pry"

root_directory = File.expand_path('../', File.dirname(__FILE__))
Dir["#{root_directory}/**/spec/**/support/**/*.rb"].each { |f| require f }
