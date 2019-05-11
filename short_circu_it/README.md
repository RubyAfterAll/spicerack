# [ShortCircuIt](https://www.youtube.com/watch?v=XtP88AGsslo)

Memoize methods safely with parameter and dependency observation

[![Build Status](https://semaphoreci.com/api/v1/freshly/spicerack/branches/master/badge.svg)](https://semaphoreci.com/freshly/spicerack)
[![Maintainability](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/maintainability)](https://codeclimate.com/github/Freshly/spicerack/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/test_coverage)](https://codeclimate.com/github/Freshly/spicerack/test_coverage)

* [Installation](#installation)
* [What's memoization?](#whats-memoization)
* [Usage](#usage)
   * [Static methods](#static-methods)
   * [Arguments](#arguments)
   * [Instance State](#instance-state)
   * [Observables](#observables)
* [Development](#development)
* [Contributing](#contributing)
* [License](#license)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'short_circu_it'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install short_circu_it

## What's memoization?

ShortCircuIt provides method memoization with awareness for arguments, instance state, weather, Oxford commas, or anything else you can think to throw at it.

Imagine you have this method in your code, for some reason:

```ruby
def nth_digit_of_pi(n)
  # MATH
end
```

Now imagine you need to show the 1000th digit of pi in three places on a single webpage. Do you calculate it three times, or do you assign it to a variable once and use that variable three times? The latter is memoization; the former is... also an option.

## Usage

### Static methods

In the simplest case, `ShortCircuIt` is no harder to forget than the method name itself:

```ruby
class TheClassiest
  include ShortCircuIt
  
  def how_methodical
    puts "Pity on my sysop!"
    this_must_be_expensive
  end
  memoize :how_methodical
end

the_classiest = TheClassiest.new
3.times.map { the_classiest.how_methodical }
# Pity on my sysop!
#=> [
#   "One Billion Dollars",
#   "One Billion Dollars",
#   "One Billion Dollars"
# ]
```

Even though the method gets called 3 times, the code only gets executed once.

### Arguments

But what if your method takes arguments? We gotcha covered - memoization is specific to the arguments passed to the method, so a call with the same arguments will return the memoized value, while a call with different arguments will execute the method again.

```ruby
the_classiest.how_methodical(1)
# Pity on my sysop!
#=> "One Billion Dollars"

the_classiest.how_methodical(1)
#=> "One Billion Dollars"

the_classiest.how_methodical(2)
# Pity on my sysop!
#=> "Two Billion Dollars"
```

### Instance State

Sometimes instances are stateful and mutable. By default, ShortCircuIt will watch an object's state via its `hash` value, so the memoization is broken when its attributes change:

```ruby
the_classiest.how_methodical(1)
# Pity on my sysop!
#=> "One Billion Dollars"

the_classiest.how_methodical(1)
#=> "One Billion Dollars"

the_classiest.orders_of_magnitude = 8
the_classiest.how_methodical(1)
# Pity on my sysop!
#=> "One Hundred Million Dollars"
```

### Observables

Maybe I have a method I'd like memoize on a complex object with many unrelated attributes:

```ruby
class TheAntist
  attr_accessor :root_beer_floats_are_delicious, :physics, :weight_of_the_universe
  
  def how_much_ants_can_carry
    # SCIENCE
  end
  memoize :how_much_ants_can_carry, observes: :physics
  # Can also be
  memoize :how_much_ants_can_carry, observes: [:physics, :weight_of_the_universe]
end

antist = TheAntist.new
antist.how_much_ants_can_carry
# => .5 oz

# When we change an unobserved value, the memoiozation persists:
antist.root_beer_floats_are_delicious = true
antist.how_much_ants_can_carry
# => .5 oz

# But if we change the observed value, the memoization is broken:
antist.physics = :parallel_universe
antist.how_much_ants_can_carry
# => 100 lbs
```

## Development

Consult Spicerack's [development instructions](../README.md#development) for more info.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Freshly/spicerack.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
