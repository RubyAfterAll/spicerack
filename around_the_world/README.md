# AroundTheWorld

A metaprogramming module which allows you to wrap any method easily.

[![Gem Version](https://badge.fury.io/rb/around_the_world.svg)](https://badge.fury.io/rb/around_the_world)
[![Build Status](https://semaphoreci.com/api/v1/freshly/spicerack/branches/master/badge.svg)](https://semaphoreci.com/freshly/spicerack)
[![Maintainability](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/maintainability)](https://codeclimate.com/github/Freshly/spicerack/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/test_coverage)](https://codeclimate.com/github/Freshly/spicerack/test_coverage)

* [Installation](#installation)
* [Usage](#usage)
* [Development](#development)
* [Contributing](#contributing)
* [License](#license)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "around_the_world"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install around_the_world
```

## Usage

Define a method that gets called _around_ the given instance method:

```ruby
class SomeClass
  include AroundTheWorld

  def did_something_happened?
    true
  end

  around_method :did_something_happened? do |*args|
    things_happened = super(*args)

    if things_happened
      "Something happened!"
    else
      "Nothing to see here..."
    end
  end
end
```

```
> SomeClass.new.did_something_happened?
=> "Something happened!"
```

`around_method` accepts an option hash `prevent_double_wrapping_for: [Object]`. If defined, this prevents wrapping the method twice for a given purpose. It accepts any value:


```ruby
class SomeClass
  include AroundTheWorld

  def some_method
    "method behavior"
  end

  around_method :some_method, prevent_double_wrapping_for: :memoization do |*args|
    @memoized ||= super(*args)
  end

  around_method :some_method, prevent_double_wrapping_for: :memoization do |*args|
    @memoized ||= super(*args)
  end
end
```

Results in:

```
# => AroundTheWorld::DoubleWrapError:
     "Module AroundTheWorld:ProxyModule:memoization already defines the method :some_method"
```

It works for class methods too:

```ruby
class SomeClass
  class << self
    include AroundTheWorld

    def a_singleton_method; end

    around_method :a_singleton_method do |*args|
      super(*args)

      "It works for class methods too!"
    end
  end
end
```

```
> SomeClass.a_singleton_method
=> "It works for class methods too!"
```

## Development

Consult Spicerack's [development instructions](../README.md#development) for more info.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Freshly/spicerack.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
