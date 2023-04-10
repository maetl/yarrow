Yarrow
======

[![Gem Version](https://img.shields.io/gem/v/yarrow.svg)][gem]
[![Build Status](https://img.shields.io/github/workflow/status/maetl/yarrow/ruby/main)][github]

[gem]: https://rubygems.org/gems/yarrow
[github]: https://github.com/maetl/yarrow

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

| Version | Features                                        |
|---------|-------------------------------------------------|
| `0.9`   | Support standard text formats and linked assets |
| `0.10`  | Custom Markdown components                      |
| `0.11`  | Publishing support for S3 and GitHub/Netlify    |
| `0.12`  | Clean up local web server and watcher           |
| `0.13`  | Content structure transformations               |
| `1.0`   | Reintroduce generic command line runner         |

License
-------

MIT. See the `LICENSE` file in the source distribution.

Contact
-------

Author: Mark Rickerby <me@maetl.net>
