# Spicerack

[![Build Status](https://semaphoreci.com/api/v1/freshly/spicerack/branches/master/badge.svg)](https://semaphoreci.com/freshly/spicerack)
[![Maintainability](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/maintainability)](https://codeclimate.com/github/Freshly/spicerack/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/7e089c2617c530a85b17/test_coverage)](https://codeclimate.com/github/Freshly/spicerack/test_coverage)

This collection of gems will spice up your rails and kick your rubies up a notch. Bam!

## Installation

Add this line to your application's Gemfile:

```ruby
gem "spicerack"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spicerack

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Freshly/spicerack.

To add a new gem to the spicerack:

```
cd spicerack
bundle gem GEM
cd GEM
rm -rf .git
rm .travis.yml
rm .gitignore
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
