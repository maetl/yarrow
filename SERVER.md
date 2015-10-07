# Local Dev Server

Yarrow provides a local dev server for quick previews and incremental development of documentation.

## Getting Started

To start the server in the current working directory, run `yarrow-server`:

```
$ yarrow-server
```

## Directory Indexes

There are several options that control the behavior of directory indexes:

- `default_index` sets the name of the file used as a default directory index (usually `index.html`).
- `auto_index` generates a listing of files in the directory when no default index is provided.

## Default Content Type

To set a default content type for files without an automatically detected MIME type or extension, use `default_type`:

```
default_type: 'text/html'
```

## Rack Configuration

The following options are available under the `server` entry in the main configuration:

|Option|Type|Description|Default|
|-|-|-|-|
|**port**|Integer|Local port for the server to listen on|`8888`|
|**host**|String|Local host for the server to listen on|`localhost`|
|**handler**|Symbol (one of `:thin`, `:webrick`, etc)|Specifies the webserver implementation that handles requests|`:thin`|
|**middleware**|Array|List of Rack middleware to be injected as plugins|

Additional configuration options that are relevant:

`config.output_dir`: If specified, determines the docroot. Otherwise the server defaults to the current working directory.
