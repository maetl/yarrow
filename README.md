Yarrow
======

[![Gem Version](http://img.shields.io/gem/v/yarrow.svg)][gem]
[![Build Status](http://img.shields.io/travis/maetl/yarrow.svg)][travis]
[![Dependency Status](http://img.shields.io/gemnasium/maetl/yarrow.svg)][gemnasium]
[![Code Climate](http://img.shields.io/codeclimate/github/maetl/yarrow.svg)][codeclimate]
[![Coverage Status](http://img.shields.io/coveralls/maetl/yarrow.svg)][coveralls]

[gem]: https://rubygems.org/gems/yarrow
[travis]: https://travis-ci.org/maetl/yarrow
[gemnasium]: https://gemnasium.com/maetl/yarrow
[codeclimate]: https://codeclimate.com/github/maetl/yarrow
[coveralls]: https://coveralls.io/r/maetl/yarrow

Yarrow is a tool for generating well structured documentation from a variety of input sources.

Unlike most static site generators and code documentation tools, Yarrow is written with design and content-strategy in mind. It does not impose its own structure on your content. This makes it appropriate for building static sites and blogs as well as style guides and API docs.

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

Yarrow is an extraction from several existing private projects. This repo is in alpha state, which means that many of the useful features are not yet folded into this codebase.

Yarrow is being slowly developed as a part-time project to scratch a few itches. New features and bugfixes are pushed straight to master, and releases of the Gem are kept more or less in sync with the planned roadmap.

Roadmap
-------

A rough sketch of the project direction.

| Version | Features |
|---------|----------|
| `0.3`   | **[Asset pipeline and local dev server](https://github.com/maetl/yarrow/issues/48)** |
| `0.4`   | Default media type mapping, collector, markup converters |
| `0.5`   | Content model/object mapping, template/site context |
| `0.6`   | HTML tag helpers, default layout templates |
| `0.7`   | Rake integration, task library |
| `0.8`   | Generic command line runner |
| `0.9`   | Refactoring, performance fixes, lock down API |

License
-------

MIT. See the `LICENSE` file in the source distribution.

Contact
-------

Author: Mark Rickerby <me@maetl.net>
