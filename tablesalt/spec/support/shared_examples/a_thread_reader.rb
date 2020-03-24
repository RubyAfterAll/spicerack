# frozen_string_literal: true

# Required contexts:
#   method
#      - the symbol used for reading, that the receiver should respond to
#   thread_key
#      - the key the thread accessor actually uses under the hood
#   receiver
#      - the receiver of the accessor methods.
#   private?
#      - boolean, true if the method is expected to be private. Default: true
RSpec.shared_examples "a thread reader" do
  subject { receiver.__send__(method) }

  let(:value) { double }
  let(:private?) { true }

  before { Thread.current[thread_key] = value }

  after { Thread.current[thread_key] = nil }

  it { is_expected.to eq value }

  it "has expected privacy" do
    if private?
      expect { receiver.public_send(method) }.to raise_error(NoMethodError)
    else
      expect { receiver.public_send(method) }.not_to raise_error
    end
  end
end
