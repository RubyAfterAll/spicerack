# Spicerack::Styleguide

Wanna write code the Freshly way? Inherit this gem in your rubocop.yml and keep your code fresh

[![Gem Version](https://badge.fury.io/rb/spicerack-styleguide.svg)](https://badge.fury.io/rb/spicerack-styleguide)
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
gem 'spicerack-styleguide'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spicerack-styleguide

## Usage

Add the following to the top of your rubocop.yml file - this will set your default Rubocop rules to anything we've set (which is most everything).

```yaml
inherit_gem:
  spicerack-styleguide:
    - rubocop.yml
```

If you'd like to override any rules we've set, just list them underneath the inherit block:

```yaml
inherit_gem:
  spicerack-styleguide:
    - rubocop.yml
    
# You're gonna want a flak jacket for this one
Style/StringLiterals:
  Enabled: true
  EnforcedStyle: single_quotes
```

## Development

This... is a yml. You don't develop it. Go home, boilerplate gem README text, you're drunk!

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Freshly/spicerack.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
