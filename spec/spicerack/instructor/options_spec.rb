# frozen_string_literal: true

RSpec.describe Instructor::Options, type: :module do
  include_context "with an example instructor", described_class

  describe ".option" do
    it_behaves_like "an instructor with a class collection attribute", :option, :_options
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :option do
      let(:root_class) { example_instructor_class }
    end
  end

  describe ".after_initialize" do
    before do
      example_instructor_class.__send__(:option, :test_option1, default: :default_value1)
      example_instructor_class.__send__(:option, :test_option2) { :default_value2 }
    end

    it_behaves_like "a class with attributes having default values" do
      subject(:instance) { example_instructor }

      let(:input) { key_values }
    end
  end
end
