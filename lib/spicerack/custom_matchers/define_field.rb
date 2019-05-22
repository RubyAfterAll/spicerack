# frozen_string_literal: true

# RSpec matcher that tests usage of `.field`
#
#     class Example < Spicerack::HashModel
#       field :foo, :datetime
#       field :bar, :integer
#     end
#
#     RSpec.describe Example, type: :hash_model do
#       subject { described_class.new.tap { |model| model.data = data } }
#
#       let(:data) { {} }
#
#       it { is_expected.to define_field :foo, :datetime }
#       it { is_expected.to define_field :bar, :integer }
#     end

RSpec::Matchers.define :define_field do |field, type = nil, default: nil|
  match do
    expect(test_subject.attribute_types[field.to_s].type).to eq type unless type.nil?
    expect(test_subject._default_attributes[field.to_s].value).to eq default unless default.nil?
    expect(test_subject._fields).to include field
  end
  description { "define field #{field}" }
  failure_message { "expected #{test_subject} to define field #{field} #{with_details(type, default)}" }

  def with_details(type, default)
    [ with_type(type), with_default(default) ].compact.join(" ")
  end

  def with_type(type)
    "of type #{type}" unless type.nil?
  end

  def with_default(default)
    "with default #{default}" unless default.nil?
  end

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end
