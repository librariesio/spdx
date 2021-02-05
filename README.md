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
Spdx.valid?("(MIT OR AGPL-3.0+)")
=> true
```

```ruby
Spdx.parse("MIT OR AGPL-3.0+")
=> LogicalOr+OrExpression4 offset=0, "MIT OR AGPL-3.0+":
  License+LicenseId0 offset=0, "MIT" (idstring)
  LicensePlus+SimpleExpression0 offset=7, "AGPL-3.0+" (license_id):
    License+LicenseId0 offset=7, "AGPL-3.0" (idstring)
```

```ruby
Spdx.normalize("Mit OR agpl-3.0+ AND APACHE-2.0")
=> "(MIT OR (AGPL-3.0+ AND Apache-2.0))"
```

### Nodes

Parsed SPDX license expressions can be a number of various nodes. Each of these nodes share a few methods, most notably `text_value` which contains the text that spans that node, and `licenses` which contains an array of individual licenses used in that portion of the expression. Below are the nodes in more detail, and their additional methods.

#### `License`

This node represents a single license, and is the result of the most simple form of expression, e.g. `Spdx.parse("MIT")`. It can also be found as a child node of other nodes.

#### `LicensePlus`

This node represents the current version of a license or any later version, e.g. `Spdx.parse("CDDL-1.0+")`. The inner license node can be found via the `child` method.

#### `LicenseRef`

This node represents a reference to a license not defined in the SPDX license list, e.g. `Spdx.parse("LicenseRef-23")`.

#### `DocumentRef`

Similar to `LicenseRef`, this node also represents a reference to a license not defined in the SPDX license list, e.g. `Spdx.parse("DocumentRef-spdx-tool-1.2:LicenseRef-MIT-Style-2")`.

#### `LicenseException`

This node represents an exception to a license. See `With`.

#### `With`

This node represents a license with an SPDX-defined license exception, e.g. `Spdx.parse("GPL-2.0-or-later WITH Bison-exception-2.2")`. This node has two extra methods, `license` and `exception`, which return the nodes for the license portion of the expression and the exception portion of the expression, respectively.

#### `LogicalAnd`

This node represents an "AND" expression, e.g. `Spdx.parse("LGPL-2.1-only AND MIT")`. This node has two extra methods, `left` and `right`, which return the node for the left side of the expression and the node for the right side of the expression, respectively. Any node can be the child of `LogicalAnd`, including `LogicalAnd`/`LogicalOr`.

`Spdx.parse("(MIT AND GPL-1.0) AND MPL-2.0 AND Apache-2.0")` would result in the following tree:

```txt
LogicalAnd
├── GroupedExpression
│   └── LogicalAnd
│       ├── License (MIT)
│       └── License (GPL-1.0)
└── LogicalAnd
    ├── License (MPL-2.0)
    └── License (Apache-2.0)
```

#### `LogicalOr`

The same as `LogicalAnd`, but for "OR" expressions.

## Testing

Run the tests with:

    $ bundle exec rspec

## Contributing

1. Fork it ( https://github.com/librariesio/spdx/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
