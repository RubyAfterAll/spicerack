# frozen_string_literal: true

module Substance
  module Objects
    module Output
      extend ActiveSupport::Concern

      included do
        include AroundTheWorld

        class_attribute :_outputs, instance_writer: false, default: []

        delegate :_outputs, to: :class

        after_validation do
          next unless validated?

          _outputs.each do |key|
            public_send("#{key}=".to_sym, _defaults[key].value) if _defaults.key?(key) && public_send(key).nil?
          end
        end
      end

      class_methods do
        def inherited(base)
          base._outputs = _outputs.dup
          super
        end

        private

        def output(output, default: nil, &block)
          _outputs << output
          define_attribute output
          define_default output, static: default, &block
          ensure_validation_before output
          ensure_validation_before "#{output}=".to_sym
        end

        def ensure_validation_before(method)
          around_method method do |*args, **opts|
            attr_name = method.to_s.delete("=").to_sym
            raise NotValidatedError unless validated? || _options.include?(attr_name) || _arguments.include?(attr_name)

            # TODO: replace with `super(...)` when <= 2.6 support is dropped
            if RUBY_VERSION < "2.7" && opts.blank?
              super(*args)
            else
              super(*args, **opts)
            end
          end
        end
      end

      def outputs
        return {} if _outputs.empty?

        output_struct.new(*_outputs.map(&method(:public_send)))
      end

      def output_struct
        Struct.new(*_outputs)
      end
    end
  end
end
