# Spicerack::Styleguide

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/spicerack/styleguide`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

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

See https://github.com/Freshly/spicerack/blob/master/README.md

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Freshly/spicerack.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
