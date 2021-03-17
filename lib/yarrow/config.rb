# Replacement for the legacy Hashie::Mash/Module mixin configuration
# pattern. This provides the same API (chaining nested attribute calls) but
# handles schema validation and doesn’t pollute other namespaces.
module Yarrow
  module Config
    # Basic defaults which can be used to populate HTML metadata as well as
    # used in CLI listings and other generated docs. The default H1 if no
    # specific output config or template themes are provided.
    #
    # For larger web publishing projects, this should be moved out into a
    # template context or language/translation files to make it editable
    # for a larger group of people.
    Meta = Yarrow::Schema::Value.new(
      :title,
      :author
      # :copyright TODO: what other basic details to include?
    )

    # Dev server config. This is mainly useful if you want to set up a specific
    # chain of Rack middleware and handlers. If you don’t care about default
    # directory indexes or port handling, you can completely ignore this.
    #
    # There are many better live reloading options available in JS, so the Rack
    # infrastructure here should be ignored for UI-heavy jobs. It’s otherwise
    # fine for slower-paced general purpose web publishing.
    #
    # The default index config could possibly move into a dedicated namespace
    # in future if it makes sense to use the underlying graph infrastructure
    # as a live lookup rather than a compiler-generated artifact. This would
    # mean rather than doing a ls on the directory, the index pages would
    # grab a list of entries out of a graph projection for the directory.
    Server = Yarrow::Schema::Value.new(
      :live_reload,
      :auto_index,
      :default_index,
      :default_type,
      :port,
      :host,
      :handler,
      :middleware,
      :root_dir
    )

    # Top level root config namespace. Source, content and output are directory
    # paths and should be the only required defaults for a complete batch run.
    #
    # Additional server config is optional and only needed if running the dev
    # server locally.
    #
    # TODO: meta should be union of Type::Optional and Config::Meta
    Instance = Yarrow::Schema::Value.new(
      source: Pathname,
      content: Pathname,
      output_dir: Pathname,
      meta: Yarrow::Schema::Type::Any,
      server: Yarrow::Schema::Type::Any
    )
  end
end
