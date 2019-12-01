# frozen_string_literal: true

module Spicerack
  module RSpec
    module Configurable
      module Matchers
        # RSpec matcher to test options of a Configurable class
        #
        #     class ExampleConfiguration
        #       include Spicerack::Configurable
        #
        #       option :foo
        #       option :bar, default: :baz
        #     end
        #
        #     RSpec.describe ExampleConfiguration, type: :configuration do
        #       subject { described_class.new }
        #
        #       it { is_expected.to define_config_option :foo }
        #       it { is_expected.to define_config_option :bar, default: :baz }
        #     end
        define :define_config_option do |option, default: nil|
          description { "define config option #{option}" }
          failure_message { "expected #{@obj} to define config option #{option} #{with_default(default)}".strip }

          match do |obj|
            @obj = obj

            if obj.is_a? Spicerack::Configurable::ConfigObject
              expect(obj).to define_option option, default: default
            else
              expect(obj).to respond_to :config
              expect(obj.config.instance_variable_get(:@config)).to be_present
              expect(obj.config.instance_variable_get(:@config)).to define_option option, default: default
            end
          end

          def with_default(default)
            "with default #{default}" unless default.nil?
          end
        end
      end
    end
  end
end
