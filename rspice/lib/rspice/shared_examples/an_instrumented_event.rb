# frozen_string_literal: true

# RSpec shared example to spec event instrumentation.
#
# Usage:
#
# RSpec.describe GitClient, type: :client do
#   subject(:instance) { described_class.new(github: true) }
#
#   describe "#retrieve_all" do
#     subject(:retrieve_all) { instance.__send__(:retrieve_all, type, *arguments, **options) }
#
#     before { retrieve_all }
#
#     it_behaves_like "an instrumented event", "retrieve_all_started.Git::Base.info"
#     it_behaves_like "an instrumented event", "retrieve_all_finished.Git::Base.info"
#   end
# end
RSpec.shared_examples_for "an instrumented event" do |event_name|
  subject { ActiveSupport::Notifications }

  let(:expected_event) { event_name }

  let(:expected_data) do
    {}
  end

  let(:expected_args) do
    [ expected_event ].push(expected_data).compact
  end

  it { is_expected.to have_received(:instrument).with(*expected_args) }
end
