# frozen_string_literal: true

RSpec.shared_context "with an example instructor" do |extra_instructor_modules = nil|
  subject(:example_instructor) { example_instructor_class.new(**input) }

  let(:root_instructor_modules) { [ Instructor::Core ] }
  let(:instructor_modules) { root_instructor_modules + Array.wrap(extra_instructor_modules) }

  let(:root_instructor_class) { Class.new(Spicerack::AttributeObject) }
  let(:example_instructor_class) do
    root_instructor_class.tap do |instructor_class|
      instructor_modules.each { |instructor_module| instructor_class.include instructor_module }
    end
  end

  let(:input) do
    {}
  end
end
