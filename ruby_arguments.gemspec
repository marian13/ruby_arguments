# frozen_string_literal: true

require_relative "lib/ruby_arguments/version"

Gem::Specification.new do |spec|
  spec.name = "ruby_arguments"
  spec.version = RubyArguments::VERSION
  spec.authors = ["Marian Kostyk"]
  spec.email = ["mariankostyk13895@gmail.com"]

  spec.summary = "Ruby Arguments encapsulate method positional arguments (args), keyword arguments (kwargs), and an optional block (block) in a single value object (null object is also available)."
  spec.description = "Ruby Arguments encapsulate method positional arguments (args), keyword arguments (kwargs), and an optional block (block) in a single value object (null object is also available)."
  spec.homepage = "https://github.com/marian13/ruby_arguments"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  spec.files = ::Dir["LICENSE.txt", "README.md", "lib/**/*"]

  spec.require_paths = ["lib"]
end
