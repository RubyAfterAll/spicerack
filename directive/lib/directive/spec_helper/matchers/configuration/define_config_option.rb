# frozen_string_literal: true

require "substance/rspec/custom_matchers/define_option"

module Directive
  module SpecHelper
    module Matchers
      module Configuration
        # RSpec matcher to test options of a Configurable class
        #
        #     class ExampleConfiguration
        #       extend Directive
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
        define :define_config_option do |option, **config_options|
          attr_reader :obj, :option, :default, :default_expected

          description { "define config option #{option.inspect}#{with_default_message}" }
          failure_message { "expected #{obj} to define config option #{option.inspect}#{with_default_message}" }

          match do |obj|
            config_options.assert_valid_keys(:default)

            @obj = obj
            @options = option

            @default_expected = config_options.key?(:default)
            @default = config_options[:default]

            if obj.is_a? Directive::ConfigObject
              expect(obj).to define_option option.to_sym, default: default
            else
              expect(obj).to respond_to :config
              expect(obj.config.instance_variable_get(:@config)).to be_present
              expect(obj.config.instance_variable_get(:@config)).to define_option option.to_sym, default: default
            end
          end

          def with_default_message
            return unless default_expected

            " with default #{default.inspect}"
          end
        end
      end
    end
  end
end
