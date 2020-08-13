# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "spdx/version"

Gem::Specification.new do |spec|
  spec.name          = "spdx"
  spec.version       = Spdx::VERSION
  spec.authors       = ["Tidelift, Inc."]
  spec.email         = ["support@tidelift.com"]
  spec.summary       = "A SPDX license parser"
  spec.homepage      = "https://github.com/librariesio/spdx"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "treetop", "~> 1.6"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 12"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "rubocop"
end
