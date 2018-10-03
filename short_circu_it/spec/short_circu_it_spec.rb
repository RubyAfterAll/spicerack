# frozen_string_literal: true

require_relative "./spec_helper"

RSpec.describe ShortCircuIt do
  it "has a version number" do
    expect(ShortCircuIt::VERSION).not_to be nil
  end

  describe ".memoize" do
    let(:memoized_class) do
      Class.new do
        include ShortCircuIt

        def method_without_arguments
          expensive_method(rand(100))
        end

        def method_with_arguments(*args)
          expensive_method(args.first)
        end

        def expensive_method(nth)
          last_value = 0
          current_value = 1

          nth.times do
            next_value = last_value + current_value
            last_value = current_value
            current_value = next_value
          end

          current_value
        end

        def observed_value_one
          @observed_value_one ||= 1
        end

        def observed_value_two
          @observed_value_two ||= 2
        end
      end
    end

    let(:memoized_instance) { memoized_class.new }
    let(:memoized_module) { memoized_class::MemoizedMethods }
    let(:all_observer_methods) { %i[observed_value_one observed_value_two] }

    let(:target_change) { nil }
    let(:argument_change) { nil }

    before do
      stub_const("MemoizedClass", memoized_class)
      allow(memoized_instance).to receive(:expensive_method).and_call_original
    end

    shared_context "when it observes nothing" do
      before { memoized_class.__send__(:memoize, memoized_method, observes: nil) }
    end

    shared_context "when it observes itself" do
      before { memoized_class.__send__(:memoize, memoized_method) }
    end

    shared_context "when it observes one method" do
      let(:observed_method) { all_observer_methods.sample }

      before { memoized_class.__send__(:memoize, memoized_method, observes: observed_method) }
    end

    shared_context "when it observes multiple methods" do
      let(:observed_methods) { all_observer_methods }

      before { memoized_class.__send__(:memoize, memoized_method, observes: observed_methods) }
    end

    shared_context "when hash changes" do
      let(:target_change) { allow(memoized_instance).to receive(:hash).and_return(memoized_instance.hash + 1) }
    end

    shared_context "when observed method changes" do
      let(:target_change) do
        allow(memoized_instance).
          to receive(observed_method).
          and_return(memoized_instance.public_send(observed_method).hash + 1)
      end
    end

    shared_context "when one of the observed methods changes" do
      let(:changed_method) { observed_methods.sample }
      let(:target_change) do
        allow(memoized_instance).
          to receive(changed_method).
          and_return(memoized_instance.public_send(changed_method) + 1)
      end
    end

    shared_context "when both observed methods change" do
      let(:target_change) do
        observed_methods.each do |changed_method|
          allow(memoized_instance).
            to receive(changed_method).
            and_return(memoized_instance.public_send(changed_method) + 1)
        end
      end
    end

    shared_examples_for "it defines a memoization method" do
      subject { memoized_module.instance_methods }

      it { is_expected.to include memoized_method }
    end

    shared_examples_for "a memoized value" do
      let!(:initial_value) { memoized_instance.public_send(memoized_method, *arguments) }

      it "memoizes the value" do
        target_change
        argument_change
        expect(memoized_instance.public_send(memoized_method, *arguments)).to eq initial_value
        expect(memoized_instance).to have_received(:expensive_method).exactly(:once)
      end
    end

    shared_examples_for "a new value" do
      let!(:initial_value) { memoized_instance.public_send(memoized_method, *arguments) }

      it "gets a new value" do
        target_change
        argument_change
        memoized_instance.public_send(memoized_method, *arguments)
        expect(memoized_instance).to have_received(:expensive_method).twice
      end
    end

    context "when the method takes no arguments" do
      let(:memoized_method) { :method_without_arguments }
      let(:arguments) { [] }

      context "when the method observes nothing" do
        include_context "when it observes nothing"

        it_behaves_like "it defines a memoization method"

        context "when the instance does not change" do
          it_behaves_like "a memoized value"
        end

        context "when the instance changes between calls" do
          include_context "when hash changes"
          it_behaves_like "a memoized value"
        end
      end

      context "when the method observes self" do
        include_context "when it observes itself"

        it_behaves_like "it defines a memoization method"

        context "when the instance does not change" do
          it_behaves_like "a memoized value"
        end

        context "when the instance changes between calls" do
          include_context "when hash changes"
          it_behaves_like "a new value"
        end
      end

      context "when the method observes one method" do
        include_context "when it observes one method"

        it_behaves_like "it defines a memoization method"

        context "when the observed method does not change" do
          it_behaves_like "a memoized value"
        end

        context "when the observed method changes between calls" do
          include_context "when observed method changes"
          it_behaves_like "a new value"
        end
      end

      context "when the method observes multiple methods" do
        include_context "when it observes multiple methods"

        it_behaves_like "it defines a memoization method"

        context "when neither observed method changes" do
          it_behaves_like "a memoized value"
        end

        context "when one observed method changes" do
          include_context "when one of the observed methods changes"
          it_behaves_like "a new value"
        end

        context "when both observed methods change" do
          include_context "when both observed methods change"
          it_behaves_like "a new value"
        end
      end
    end

    context "when the method takes arguments" do
      let(:memoized_method) { :method_with_arguments }
      let(:arguments) { Array(rand(1..4)) { rand(100) } }

      context "when arguments do NOT change between calls" do
        context "when the method observes nothing" do
          include_context "when it observes nothing"

          it_behaves_like "it defines a memoization method"

          context "when the instance does not change" do
            it_behaves_like "a memoized value"
          end

          context "when the instance changes between calls" do
            include_context "when hash changes"
            it_behaves_like "a memoized value"
          end
        end

        context "when the method observes self" do
          include_context "when it observes itself"

          it_behaves_like "it defines a memoization method"

          context "when the instance does not change" do
            it_behaves_like "a memoized value"
          end

          context "when the instance changes between calls" do
            include_context "when hash changes"
            it_behaves_like "a new value"
          end
        end

        context "when the method observes one method" do
          include_context "when it observes one method"

          it_behaves_like "it defines a memoization method"

          context "when the observed method does not change" do
            it_behaves_like "a memoized value"
          end

          context "when the observed method changes between calls" do
            include_context "when observed method changes"
            it_behaves_like "a new value"
          end
        end

        context "when the method observes multiple methods" do
          include_context "when it observes multiple methods"

          it_behaves_like "it defines a memoization method"

          context "when neither observed method changes" do
            it_behaves_like "a memoized value"
          end

          context "when one observed method changes" do
            include_context "when one of the observed methods changes"
            it_behaves_like "a new value"
          end

          context "when both observed methods change" do
            include_context "when both observed methods change"
            it_behaves_like "a new value"
          end
        end
      end

      context "when arguments change between calls" do
        let(:argument_change) { arguments.push(arguments.shift + 1) }

        context "when the method observes nothing" do
          include_context "when it observes nothing"

          it_behaves_like "it defines a memoization method"

          context "when the instance does not change" do
            it_behaves_like "a new value"
          end

          context "when the instance changes between calls" do
            include_context "when hash changes"
            it_behaves_like "a new value"
          end
        end

        context "when the method observes self" do
          include_context "when it observes itself"

          it_behaves_like "it defines a memoization method"

          context "when the instance does not change" do
            it_behaves_like "a new value"
          end

          context "when the instance changes between calls" do
            include_context "when hash changes"
            it_behaves_like "a new value"
          end
        end

        context "when the method observes one method" do
          include_context "when it observes one method"

          it_behaves_like "it defines a memoization method"

          context "when the observed method does not change" do
            it_behaves_like "a new value"
          end

          context "when the observed method changes between calls" do
            include_context "when observed method changes"
            it_behaves_like "a new value"
          end
        end

        context "when the method observes multiple methods" do
          include_context "when it observes multiple methods"

          it_behaves_like "it defines a memoization method"

          context "when neither observed method changes" do
            it_behaves_like "a new value"
          end

          context "when one observed method changes" do
            include_context "when one of the observed methods changes"
            it_behaves_like "a new value"
          end

          context "when both observed methods change" do
            include_context "when both observed methods change"
            it_behaves_like "a new value"
          end
        end
      end
    end
  end
end
