# frozen_string_literal: true

RSpec.describe Tablesalt::HashedEquality, type: :concern do
  subject(:example_object) { example_class.new }

  let(:example_class) do
    Class.new.tap { |klass| klass.include described_class }
  end

  it { is_expected.to use_hash_for_equality }
end
