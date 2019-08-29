# frozen_string_literal: true

require_relative "../../shared/spec_helper"

require_relative "support/shared_context/with_an_example_facet"
require_relative "support/shared_context/with_a_bottles_active_record"
require_relative "support/shared_context/with_example_bottles"

require "active_record"
require "will_paginate"
require "will_paginate/active_record"

require "facet"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

require "support/test_classes/bottle"
require "support/test_classes/bottle_facet"
