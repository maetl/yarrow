# Local Dev Server

Yarrow provides a local dev server for quick previews and incremental development of documentation.

## Getting Started

To start the server in the current working directory, run `yarrow-server`:

```
$ yarrow-server
```

## Configuration

The following options are available under the `server` entry in the main configuration:

|Option|Type|Description|Default|
|-|-|-|-|
|**port**|Integer|Local port for the server to listen on|`8888`|
|**host**|String|Local host for the server to listen on|`localhost`|
|**handler**|Symbol (one of `:thin`, `:webrick`, etc)|Specifies the webserver implementation that handles requests|`:thin`|

Additional configuration options that are relevant:

`config.output_dir`: If specified, determines the docroot. Otherwise the server defaults to the current working directory.
