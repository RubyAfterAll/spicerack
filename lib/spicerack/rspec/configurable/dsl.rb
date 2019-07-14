# frozen_string_literal: true

require_relative "matchers"

module Spicerack
  module RSpec
    module Configurable
      module DSL
        def nested_config_option(config_name, &block)
          describe(config_name.to_s, caller: caller) do
            subject { nested_config }

            let(:nested_config) do
              described_class.__send__(:_config_builder).__send__(:configuration).public_send(config_name)
            end

            it "defines nested config object #{config_name}" do
              described_class.configure do |config|
                expect(config).to respond_to config_name
                expect(config._nested_options).to include config_name.to_sym
                expect(config.public_send(config_name)).to be_a Spicerack::Configurable::ConfigObject
              end
            end

            instance_eval(&block)
          end
        end

        def self.included(base)
          base.extend DSL
          super
        end
      end
    end
  end
end
