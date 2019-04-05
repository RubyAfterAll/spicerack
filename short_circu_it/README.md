# [ShortCircuIt](https://www.youtube.com/watch?v=XtP88AGsslo)

[![Build Status](https://semaphoreci.com/api/v1/freshly/spicerack/branches/master/badge.svg)](https://semaphoreci.com/freshly/spicerack)
[![Maintainability](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/maintainability)](https://codeclimate.com/github/Freshly/spicerack/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/test_coverage)](https://codeclimate.com/github/Freshly/spicerack/test_coverage)

### Intelligent memoization

ShortCircuIt provides method memoization with awareness for arguments, instance state, weather, Oxford commas, or anything else you can think to throw at it.

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

Imagine you have this method in your code, for some reason:
```ruby
def nth_digit_of_pi(n)
  # MATH
end
```

Now imagine you need to show the 1000th digit of pi in three places on a single webpage. Do you calculate it three times, or do you assign it to a variable once and use that variable three times? The latter is memoization; the former is...also an option.

## Usage

### Static methods
In the simplest case, ShortCircuIt is no harder to forget than the method name itself:

```ruby
class TheClassiest
  include ShortCircuIt
  
  def how_classy_though
    puts "Pity on my sysop!"
    this_must_be_expensive
  end
  memoize :how_classy_though
end

just_classy = TheClassiest.new
3.times.map { just_classy.how_classy_though }
# Pity on my sysop!
#=> [
#   "One Billion Classes",
#   "One Billion Classes",
#   "One Billion Classes"
# ]
```

### Arguments

But what if your method takes arguments? We gotcha covered:

```ruby
just_classy.how_classy_though(1)
# Pity on my sysop!
#=> "One Billion Classes"

just_classy.how_classy_though(1)
#=> "One Billion Classes"

just_classy.how_classy_though(2)
# Pity on my sysop!
#=> "Two Billion Classes"
```

### Instance State
Sometimes instances are stateful and mutable. By default, ShortCircuIt will watch an object's state via its `hash` value, so the memoization is broken when its attributes change:
```ruby
just_classy.how_classy_though(1)
# Pity on my sysop!
#=> "One Billion Classes"

just_classy.how_classy_though(1)
#=> "One Billion Classes"

just_classy.orders_of_magnitude = 8
just_classy.how_classy_though(1)
# Pity on my sysop!
#=> "One Hundred Million Classes"
```

### Observables

_`memoize` accepts the argument `observes` with either a symbol or array of symbols._

Maybe I have a method I'd like memoize on a complex object with many unrelated attributes:
```ruby
class TheAntist
  attr_accessor :root_beer_floats_are_delicious, :actual_science
  
  def body_weight_ants_can_carry
    # SCIENCE
  end
  memoize :body_weight_ants_can_carry, observes: :actual_science
end

antist = TheAntist.new
antist.body_weight_ants_can_carry
# => Most of it

antist.root_beer_floats_are_delicious = true
antist.body_weight_ants_can_carry
# => Most of it
```

The second call to `body_weight_ants_can_carry` returns the memoized value, despite root beer flotat's deliciousness changing. `actual_science` stayed constant, so the memoized value did as well.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Freshly/spicerack.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
