# frozen_string_literal: true

# RSpec matcher to assert the definition of a thread accessor
#
#     class MyClass
#       include Tablesalt::ConfigDelegation
#
#       thread_reader :a_thread_key
#     end
#
#     RSpec.describe MyClass do
#       subject { described_class }
#
#       it { is_expected.to define_thread_reader :a_thread_key }
#     end
RSpec::Matchers.define :define_thread_reader do |method_name, thread_key|
  attr_reader :subject, :method_name, :thread_key

  description { "defines thread reader #{method_name.inspect} with thread key #{thread_key.inspect}" }

  failure_message { "expected #{subject_module} to define thread reader #{method_name.inspect} with thread key #{thread_key.inspect}" }
  failure_message_when_negated { "expected #{subject_module} not to define thread reader #{method_name.inspect} with thread key #{thread_key.inspect}" }

  match_unless_raises do |subject|
    @subject = subject
    @method_name = method_name
    @thread_key = thread_key.to_sym

    with_value_on_thread do
      expect(instance).to be_respond_to(method_name, true)
      expect(klass).to be_respond_to(method_name, true)

      expect(instance.__send__(method_name)).to eq stubbed_value
      expect(klass.__send__(method_name)).to eq stubbed_value
    end

    true
  end

  private

  def with_value_on_thread
    Thread.current[thread_key] = stubbed_value

    yield

    Thread.current[thread_key] = nil
  end

  def subject_module
    subject.is_a?(Module) ? subject : subject.class
  end

  def klass
    @klass ||=
      case subject
      when Class
        subject
      when Module
        Class.new(subject)
      else
        subject.class
      end
  end

  def instance
    return subject unless subject.is_a?(Module)

    @instance ||= begin
      allow(klass).to receive(:initialize).with(any_args)
      subject.new
    end
  end

  def stubbed_value
    @stubbed_value ||= double("Thread value")
  end
end
