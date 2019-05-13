# frozen_string_literal: true

require "rspec"
require "faker"

require "active_support/core_ext/array/wrap"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/object/inclusion"

require "rspice/version"
require "rspice/errors"

require "rspice/rspec_configuration"
require "rspice/custom_matchers"
require "rspice/shared_context"
require "rspice/shared_examples"

module Rspice; end
