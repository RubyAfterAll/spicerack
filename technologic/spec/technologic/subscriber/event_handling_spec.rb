# frozen_string_literal: true

RSpec.describe Technologic::Subscriber::EventHandling do
  describe ".on_event" do
    subject(:on_event) { example_class.on_event(&event_handler) }

    let(:example_class) { Class.new.include(described_class) }

    let(:event_handler) do
      ->(_event) { :event_handler }
    end

    it "adds to _event_handlers" do
      expect { on_event }.to change { example_class._event_handlers }.from([]).to([ event_handler ])
    end
  end

  describe ".trigger" do
    subject(:trigger) { example_class.trigger(event) }

    let(:example_class) { Class.new.include(described_class) }
    let(:event) { instance_double(Technologic::Event) }
    let(:event_handler) do
      ->(_event) { :event_handler }
    end

    before do
      allow(example_class).to receive(:_event_handlers).and_return(_event_handlers)
      allow(event_handler).to receive(:call)
    end

    context "when there are no event handlers" do
      let(:_event_handlers) { [] }

      it "does not error" do
        expect { trigger }.not_to raise_error
      end
    end

    context "when there is an event handler" do
      let(:_event_handlers) { [ event_handler ] }

      it "calls the event handler" do
        trigger
        expect(event_handler).to have_received(:call).with(event)
      end
    end

    context "when there are many event handlers" do
      let(:second_event_handler) do
        ->(_event) { :second_event_handler }
      end
      let(:_event_handlers) { [ event_handler, second_event_handler ] }

      before { allow(second_event_handler).to receive(:call) }

      it "calls the event handlers in order" do
        trigger
        expect(event_handler).to have_received(:call).ordered.with(event)
        expect(second_event_handler).to have_received(:call).ordered.with(event)
      end
    end
  end

  describe ".inherited" do
    let(:base_class) { Class.new.include(described_class) }
    let(:parentA_class) { Class.new(base_class) }
    let(:parentB_class) { Class.new(base_class) }
    let(:childA1_class) { Class.new(parentA_class) }
    let(:childA2_class) { Class.new(parentA_class) }
    let(:childB_class) { Class.new(parentB_class) }

    let(:base_event_handler) do
      ->(_event) { :base_event_handler }
    end
    let(:parentA_event_handler) do
      ->(_event) { :parentA_event_handler }
    end
    let(:parentB_event_handler) do
      ->(_event) { :parentB_event_handler }
    end
    let(:childA1_event_handler) do
      ->(_event) { :childA1_event_handler }
    end
    let(:childA2_event_handler) do
      ->(_event) { :childA2_event_handler }
    end
    let(:childB_event_handler) do
      ->(_event) { :childB_event_handler }
    end

    before do
      base_class.on_event(&base_event_handler)
      parentA_class.on_event(&parentA_event_handler)
      parentB_class.on_event(&parentB_event_handler)
      childA1_class.on_event(&childA1_event_handler)
      childA2_class.on_event(&childA2_event_handler)
      childB_class.on_event(&childB_event_handler)
    end

    shared_examples_for "an object with inherited event handlers" do
      it "has expected _event_handlers" do
        expect(example_class._event_handlers).to eq expected_event_handlers
      end
    end

    describe "#base_class" do
      subject(:example_class) { base_class }

      let(:expected_event_handlers) { [ base_event_handler ] }

      include_examples "an object with inherited event handlers"
    end

    describe "#parentA" do
      subject(:example_class) { parentA_class }

      let(:expected_event_handlers) { [ base_event_handler, parentA_event_handler ] }

      include_examples "an object with inherited event handlers"
    end

    describe "#parentB" do
      subject(:example_class) { parentB_class }

      let(:expected_event_handlers) { [ base_event_handler, parentB_event_handler ] }

      include_examples "an object with inherited event handlers"
    end

    describe "#childA1" do
      subject(:example_class) { childA1_class }

      let(:expected_event_handlers) { [ base_event_handler, parentA_event_handler, childA1_event_handler ] }

      include_examples "an object with inherited event handlers"
    end

    describe "#childA2" do
      subject(:example_class) { childA2_class }

      let(:expected_event_handlers) { [ base_event_handler, parentA_event_handler, childA2_event_handler ] }

      include_examples "an object with inherited event handlers"
    end

    describe "#childB" do
      subject(:example_class) { childB_class }

      let(:expected_event_handlers) { [ base_event_handler, parentB_event_handler, childB_event_handler ] }

      include_examples "an object with inherited event handlers"
    end
  end
end
