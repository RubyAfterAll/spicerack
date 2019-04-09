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

To include the RSpice tools add the following to your `rails_helper.rb`:

```ruby
require 'rspice'
```

## Custom Matchers

* [alias_method](lib/rspice/custom_matchers/alias_method.rb) tests usages of [Module#alias_method](https://apidock.com/ruby/Module/alias_method)
* [extend_module](lib/rspice/custom_matchers/extend_module.rb) tests usages of [Object#extend](https://www.apidock.com/ruby/Object/extend)
* [have_error_on_attribute](lib/rspice/custom_matchers/have_error_on_attribute.rb) tests usages of [ActiveModel::Errors](https://api.rubyonrails.org/classes/ActiveModel/Errors.html)
* [include_module](lib/rspice/custom_matchers/include_module.rb) tests usages of [Module#include](https://apidock.com/ruby/Module/include)
* [inherit_from](lib/rspice/custom_matchers/inherit_from.rb) tests inheritance of [Classes](https://apidock.com/ruby/Class)

## Shared Context

* [with_an_example_descendant_class](lib/rspice/shared_context/with_an_example_descendant_class.rb) creates a named descendant of `described_class`
* [with_callbacks](lib/rspice/shared_context/with_callbacks.rb) defines callbacks for [ActiveSupport::Callbacks](https://apidock.com/rails/ActiveSupport/Callbacks)
* [with_example_class_having_callback](lib/rspice/shared_context/with_example_class_having_callback.rb) creates a class with [ActiveSupport::Callbacks](https://apidock.com/rails/ActiveSupport/Callbacks)

## Included Helpers

### Shared Examples

#### `"a class pass method"`

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

#### `"a class with callback"`

```ruby
module State::Core
  extend ActiveSupport::Concern

  def initialize
    run_callbacks(:initialize)
  end
end

RSpec.describe State::Core, type: :module do
  describe "#initialize" do
    include_context "with example class having callback", :initialize

    subject(:instance) { example_class.new }

    let(:example_class) { example_class_having_callback.include(State::Core) }

    it_behaves_like "a class with callback" do
      subject(:callback_runner) { instance }

      let(:example) { example_class }
    end
  end
end
```
  
#### `"a versioned spicerack gem"`

```ruby
describe YourGemHere do
  it_behaves_like "a versioned spicerack gem"
end
```

#### `"an example class with callbacks"`

```ruby
module Flow::Callbacks
  extend ActiveSupport::Concern

  included do
    include ActiveSupport::Callbacks
    define_callbacks :initialize, :trigger
  end
end

RSpec.describe Flow::Callbacks, type: :module do
  subject(:example_class) { Class.new.include described_class }

  it { is_expected.to include_module ActiveSupport::Callbacks }

  it_behaves_like "an example class with callbacks", described_class, %i[initialize trigger]
end
```

#### `"an inherited property"`

```ruby
module State::Attributes
  extend ActiveSupport::Concern

  included do
    class_attribute :_attributes, instance_writer: false, default: []
  end

  class_methods do
    def inherited(base)
      base._attributes = _attributes.dup
      super
    end

    def define_attribute(attribute)
      _attributes << attribute
    end
  end
end

RSpec.describe State::Attributes, type: :module do
  let(:example_class) { Class.new.include(State::Attributes) }

  describe ".inherited" do
    it_behaves_like "an inherited property", :define_attribute, :_attributes do
      let(:root_class) { example_class }
    end
  end
end
```

#### `"an instrumented event"`

```ruby
let(:test_class) do
  Class.new do
    def initialize(user)
      @user = user
    end

    def do_a_thing
      ActiveSupport::Notifications.instrument("a_thing_was_done.namespace", user: @user)
    end
  end
end

describe "#do_a_thing" do
  subject(:do_a_thing) { instance.do_a_thing }

  let(:instance) { test_class.new(user) }
  let(:user) { double }

  before { do_a_thing }

  it_behaves_like "an instrumented event", "a_thing_was_done.namespace" do
    let(:expected_data) do
      { user: user }
    end
  end
end
```

## Development

See Spicerack development instructions [here](https://github.com/Freshly/spicerack/blob/develop/README.md#development).

To add a new example, context or matcher, add a new file to the appropriate directory in lib/rspice. Next, require the added file in its respective include file (such as `lib/rspice/custom_matchers.rb`).

## Contributing

See Spicerack contribution instructions [here](https://github.com/Freshly/spicerack/blob/develop/README.md#contributing).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
