# [Spdx](http://libraries.io/rubygems/spdx) - A SPDX license normalizer

This gem allows you to find the closest match using [FuzzyMatch](https://github.com/seamusabshere/fuzzy_match) in the [spdx-licenses](https://github.com/domcleal/spdx-licenses) list for similar (not necessarily exact) license names.

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
Spdx.find('Apache 2') # => <SpdxLicenses::License:0x007fa3a2b462c8 @id="Apache-2.0", @name="Apache License 2.0", @osi_approved=true>
```

## Testing

Run the tests with:

    $ bundle exec rake

## Contributing

1. Fork it ( https://github.com/librariesio/spdx/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
