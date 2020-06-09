# frozen_string_literal: true

module Directive
  class Reader
    include Tablesalt::StringableObject

    def initialize(config)
      @config = config
    end

    def config_eval(*path)
      Evaluator.new(path, self)
    end

    private

    attr_reader :config

    def method_missing(method_name, *)
      return mutex.synchronize { config.public_send(method_name) } if config._options.include?(method_name)
      return config._nested_builders[method_name].reader if config._nested_builders.key?(method_name)

      super
    end

    def respond_to_missing?(method_name, *)
      config._options.include?(method_name) ||
        config._nested_builders.key?(method_name) ||
        super
    end

    def mutex
      @mutex ||= Mutex.new
    end

    def stringable_attributes
      config._options + config._nested_options
    end
  end
end
