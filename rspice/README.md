# Rspice

[![Gem Version](https://badge.fury.io/rb/rspice.svg)](https://badge.fury.io/rb/rspice)
[![Build Status](https://semaphoreci.com/api/v1/freshly/spicerack/branches/master/badge.svg)](https://semaphoreci.com/freshly/spicerack)
[![Maintainability](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/maintainability)](https://codeclimate.com/github/Freshly/spicerack/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/test_coverage)](https://codeclimate.com/github/Freshly/spicerack/test_coverage)

RSpice - a collection of custom matchers and other test helpers to make your tests a little easier to write.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "rspice"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspice

## Usage

To include the RSpice tools in your rspecs, add the following to your `rails_helper.rb`:
```ruby
require 'rspice'
```

## Included Helpers

### Custom Matchers

* `alias_method`
  ```ruby
  describe "#a_method" do
    it { is_expected.to alias_method :alias_name, :target_name }
  end
  ```
* `extend_module`
  ```ruby
  describe AModule do
    it { is_expected.to extend_module AnotherModule }
  end
  ```
* `have_error_on_attribute`
  ```ruby
  describe "Validations" do
    before { instance.attribute = :invalid_value }
    
    it { is_expected.to have_error_on_attribute(:attribute).with_detail_key(:invalid) }
  end
  ```
* `include_module`
  ```ruby
  describe AClass do
    it { is_expected.to include_module SuperUsefulModule }
  end
  ```
* `inherit_from`
  ```ruby
  describe PartB do
    it { is_expected.to inherit_from Partaayyyy }
  end
  ```

### Shared Contexts

* `"with an example descendant class"`
  ```ruby
  describe ClassA do
    include_context "with an example descendant class"
    
    let(:example_class_name) { "ChildClass" }
    
    it "has a descendant class now" do
      expect(ChildClass.ancestors).to include described_class
    end
  end
  ```

### Shared Examples

* `"a class pass method"`
  ```ruby
  class SomeClass
    def self.do_something_extraordinary!(some, instance, params)
      new(some, instance, params).do_something_extraordinary!
    end
    
    attr_reader :some, :instance, :params
    
    def initialize(some, instance, params)
      @some = some
      @instance = instance
      @params = params
    end
    
    def do_something_extraordinary!
      # Important things happen here
    end
  end
  
  # some_class_spec.rb
  describe SomeClass do
    describe ".do_something_extraordinary!" do
      it_behaves_like "a class pass method", :do_something_extraordinary!
    end
  end
  ```
  
* `"a versioned spicerack gem"`
  ```ruby
  describe YourGemHere do
    it_behaves_like "a versioned spicerack gem"
  end
  ```

## Development

See Spicerack development instructions [here](https://github.com/Freshly/spicerack/blob/develop/README.md#development).

To add a new example, context or matcher, add a new file to the appropriate directory in lib/rspice. Next, require the added file in its respective include file (such as `lib/rspice/custom_matchers.rb`).

## Contributing

See Spicerack contribution instructions [here](https://github.com/Freshly/spicerack/blob/develop/README.md#contributing).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
