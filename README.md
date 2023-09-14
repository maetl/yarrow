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

Yarrow is an extraction from several existing private documentation projects. ~~This repo is in alpha state, which means that many of the useful features are not yet folded into this codebase.~~ This repo is in flux as it is being used on several live projects, but lacks documentation and a unified command line tool.

Yarrow is being slowly developed as a part-time project to scratch a few itches. New features and bugfixes are pushed straight to `main`, and releases of the Gem are kept more or less in sync with the planned roadmap.

Roadmap
-------

A rough sketch of the project direction.

| Version | Features                                        |
|---------|-------------------------------------------------|
| `0.10`  | Filename map expansion strategy                 |
| `0.11`  | Directory merge expansion strategy              |
| `0.12`  | Basename merge expansion strategy               |
| `0.13`  | Resources and Assets vocabulary                 |
| `0.14`  | Flatten namespaces and clean up modules         |
| `0.15`  | Web template mapping and markup generators      |
| `0.16`  | Document custom Markdown components             |
| `0.17`  | Publishing support for S3 and GitHub/Netlify    |
| `0.18`  | Clean up local web server and watcher           |

License
-------

MIT. See the `LICENSE` file in the source distribution.

Contact
-------

Author: Mark Rickerby <me@maetl.net>
