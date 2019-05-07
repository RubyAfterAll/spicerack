# Technologic

A clean and terse way to produce standardized, highly actionable, and data-rich logs

[![Gem Version](https://badge.fury.io/rb/technologic.svg)](https://badge.fury.io/rb/technologic)
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
gem "technologic"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install technologic

## Usage

Simply write the error class, the message as a symbol, and then as a hash anything else you want to see in the logs.

```ruby
error :ERROR_MESSAGE_HERE, HASH_KEY: INFO_TO_PASS, HASH_KEY2: INFO_TO_PASS, 
```

All error classes are available: `debug` `info` `warn` `error` `fatal`

Some examples for each:

```ruby
debug :something_is_not_perfect_here, info_wanted: the_info

info :some_logged_info_i_may_look_at, info_wanted: the_info

warn :its_weird_and_you_wanna_know, info_wanted: the_info

error :email_for_user_does_not_exist, user_id: @user.email

fatal :it_is_going_to_be_a_long_day, need_to_know: info_dump
```

## Development

Consult Spicerack's [development instructions](../README.md#development) for more info.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Freshly/spicerack.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
