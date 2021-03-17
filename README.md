Yarrow
======

[![Gem Version](http://img.shields.io/gem/v/yarrow.svg)][gem]
[![Build Status](http://img.shields.io/github/workflow/status/maetl/yarrow/workflow)][github]
[![Coverage Status](http://img.shields.io/coveralls/maetl/yarrow.svg)][coveralls]

[gem]: https://rubygems.org/gems/yarrow
[github]: https://github.com/maetl/yarrow
[coveralls]: https://coveralls.io/r/maetl/yarrow

Yarrow is a framework for generating well structured publishing outputs from a variety of input sources.

Unlike most static site generators and code documentation tools, Yarrow is written with design and content-strategy in mind. It does not impose its own structure on your content. This makes it useful for building style guides, technical docs and complex ebooks as well as static sites and blogs.

Installation
------------

Install the library and command line tool via RubyGems:

```
gem install yarrow
```

Or embed it in an existing Ruby project by adding the following line to the `Gemfile` and running `bundle`:

```
gem 'yarrow'
```

Status
------

Yarrow is an extraction from several existing private documentation projects. This repo is in alpha state, which means that many of the useful features are not yet folded into this codebase.

Yarrow is being slowly developed as a part-time project to scratch a few itches. New features and bugfixes are pushed straight to `main`, and releases of the Gem are kept more or less in sync with the planned roadmap.

Roadmap
-------

A rough sketch of the project direction.

| Version | Features |
|---------|----------|
| `0.6`   | Default media type mapping, graph collectors, markup converters |
| `0.7`   | Content model/object mapping, template/site context |
| `0.8`   | HTML publishing workflow |
| `0.9`   | PDF publishing workflow |
| `0.10`   | Media and video publishing workflow |
| `0.11`   | Generic command line runner |
| `1.0`   | Refactoring, performance fixes, lock down API |

License
-------

MIT. See the `LICENSE` file in the source distribution.

Contact
-------

Author: Mark Rickerby <me@maetl.net>
