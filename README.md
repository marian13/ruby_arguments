<!-- AUTHOR: Marian Kostyk <mariankostyk13895@gmail.com> -->
<!-- LICENSE: MIT <https://opensource.org/license/mit> -->

# Ruby Arguments

[![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white)](https://www.ruby-lang.org/en/)

[![Gem Version](https://badge.fury.io/rb/ruby_arguments.svg)](https://rubygems.org/gems/ruby_arguments) [![Gem Downloads](https://img.shields.io/gem/dt/ruby_arguments.svg)](https://rubygems.org/gems/ruby_arguments)  ![GitHub repo size](https://img.shields.io/github/repo-size/marian13/ruby_arguments) [![GitHub Actions CI](https://github.com/marian13/ruby_arguments/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/marian13/ruby_arguments/actions/workflows/ci.yml) [![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard) [![Coverage Status](https://coveralls.io/repos/github/marian13/ruby_arguments/badge.svg)](https://coveralls.io/github/marian13/ruby_arguments?branch=main) [![yard docs](http://img.shields.io/badge/yard-docs-blue.svg)](https://marian13.github.io/ruby_arguments)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Ruby Arguments encapsulate method positional arguments (`args`), keyword arguments (`kwargs`), and an optional block (`block`) in a single value object (null object is also available).

That may be useful for DSLs, caches, callbacks, custom RSpec matchers, hash keys, pattern matching and so on.

The initial Ruby Arguments implementation was extracted from the [Convenient Service](https://github.com/marian13/convenient_service).

## TL;DR

```ruby
require "ruby_arguments"

def some_method(*args, **kwargs, &block)
  RubyArguments.new(*args, **kwargs, &block)
end

##
# Or shorter from Ruby 2.7.
#
def some_method(...)
  RubyArguments.new(...)
end

args = [:foo, :bar]
kwargs = {foo: :bar, baz: :qux}
block = proc { :foo }

arguments = some_method(*args, **kwargs, &block)

arguments.args
# => [:foo, :bar]

arguments.kwargs
# => {foo: :bar, baz: :qux}

arguments.block
# => #<Proc:0x000000012a97fc18>

arguments.null_arguments?
# => false

arguments.any?
# => true

arguments.none?
# => false

arguments.empty?
# => false

arguments.present?
# => true

arguments.blank?
# => true

arguments[0]
# => :foo

arguments[:foo]
# => :bar

def some_other_method
  RubyArguments.null_arguments
end

null_arguments = some_other_method

null_arguments.null_arguments?
# => true

arguments == null_arguments
# => false

arguments.eql?(null_arguments)
# => false

arguments in [args, kwargs, block]
# => true

arguments in args:, kwargs:, :block
# => true
```

## Installation

### Bundler

Add the following line to your Gemfile:

```ruby
gem "ruby_arguments"
```

And then run:

```bash
bundle install
```

### Without Bundler

Execute the command below:

```bash
gem install ruby_arguments
```

---

Copyright (c) 2025 Marian Kostyk.
