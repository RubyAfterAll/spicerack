# frozen_string_literal: true

if defined?(Shoulda::Matchers::ActiveModel)
  RSpec.configure do |config|
    config.include(Shoulda::Matchers::ActiveModel, type: :input_object)
    config.include(Shoulda::Matchers::ActiveModel, type: :input_model)
  end
end
