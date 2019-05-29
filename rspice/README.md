# Rspice

A dash of custom matchers, a pinch of shared contexts, and shared examples (to taste) for RSpec

[![Gem Version](https://badge.fury.io/rb/rspice.svg)](https://badge.fury.io/rb/rspice)
[![Build Status](https://semaphoreci.com/api/v1/freshly/spicerack/branches/master/badge.svg)](https://semaphoreci.com/freshly/spicerack)
[![Maintainability](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/maintainability)](https://codeclimate.com/github/Freshly/spicerack/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/test_coverage)](https://codeclimate.com/github/Freshly/spicerack/test_coverage)

* [Installation](#installation)
* [Usage](#usage)
* [Custom Matchers](#custom-matchers)
* [Shared Context](#shared-context)
* [Shared Examples](#shared-examples)
* [Development](#development)
* [Contributing](#contributing)
* [License](#license)

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
* [not_change](lib/rspice/custom_matchers/not_change.rb) negated `change` matcher
* [validate](lib/rspice/custom_matchers/validate.rb) tests application and configuration of custom validators

## Shared Context

* [with_an_example_descendant_class](lib/rspice/shared_context/with_an_example_descendant_class.rb) creates a named descendant of `described_class`
* [with_callbacks](lib/rspice/shared_context/with_callbacks.rb) defines callbacks for [ActiveSupport::Callbacks](https://apidock.com/rails/ActiveSupport/Callbacks)
* [with_class_callbacks](lib/rspice/shared_context/with_class_callbacks.rb) defines callbacks for [ActiveSupport::Callbacks](https://apidock.com/rails/ActiveSupport/Callbacks)
* [with_example_class_having_callback](lib/rspice/shared_context/with_example_class_having_callback.rb) creates a class with 

## Shared Examples

* [a_class_pass_method](lib/rspice/shared_examples/a_class_pass_method.rb) tests class methods which take arguments that instantiate and call instance method of the same name
* [a_class_with_callback](lib/rspice/shared_examples/a_class_with_callback.rb) tests usage of [ActiveSupport::Callbacks](https://apidock.com/rails/ActiveSupport/Callbacks)
* [a_handler_for_the_callback](lib/rspice/shared_examples/a_handler_for_the_callback.rb) tests [ActiveSupport::Callbacks](https://apidock.com/rails/ActiveSupport/Callbacks) handler methods
* [an_example_class_with_callbacks](lib/rspice/shared_examples/an_example_class_with_callbacks.rb) tests for defined [ActiveSupport::Callbacks](https://apidock.com/rails/ActiveSupport/Callbacks)
* [an_inherited_property](lib/rspice/shared_examples/an_inherited_property.rb) tests usages of inherited [Class.class_attributes](https://apidock.com/rails/Class/class_attribute)
* [an_instrumented_event](lib/rspice/shared_examples/an_instrumented_event.rb) tests usage of [ActiveSupport::Notification](https://apidock.com/rails/ActiveSupport/Notifications)

## Development

See Spicerack development instructions [here](https://github.com/Freshly/spicerack/blob/develop/README.md#development).

To add a new example, context or matcher, add a new file to the appropriate directory in lib/rspice. Next, require the added file in its respective include file (such as `lib/rspice/custom_matchers.rb`).

## Contributing

See Spicerack contribution instructions [here](https://github.com/Freshly/spicerack/blob/develop/README.md#contributing).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
