# [Spdx](http://libraries.io/rubygems/spdx) - A SPDX license parser

This gem allows you validate and parse spdx expressions. It also contains (relatively) up to date license and license exception lists from https://github.com/spdx/license-list-data/tree/master/json
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spdx'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spdx

## Usage

```ruby
Spdx.valid_spdx?("(MIT OR AGPL-3.0+)")
=> true
```
```ruby
Spdx.parse_spdx("(MIT OR AGPL-3.0+)")
=> CompoundExpression+CompoundExpression0 offset=0, "((MIT OR AGPL-3.0+))" (body):
  Body offset=1, "(MIT OR AGPL-3.0+)":
    CompoundExpression+CompoundExpression0 offset=1, "(MIT OR AGPL-3.0+)" (body):
      Body offset=2, "MIT OR AGPL-3.0+":
        License+License0 offset=2, "MIT"
        LogicalOr+Or0 offset=5, " OR " (space1,space2)
        License+License0 offset=9, "AGPL-3.0+"
```

## Testing

Run the tests with:

    $ bundle exec rspec

## Contributing

1. Fork it ( https://github.com/librariesio/spdx/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
