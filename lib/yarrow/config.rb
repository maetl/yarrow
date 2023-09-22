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
    class Meta < Yarrow::Schema::Entity
      attribute :title, :string
      attribute :author, :string
      # :copyright TODO: what other basic details to include?
    end

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
      :middleware
    )

    # Yarrow::Schema.define do
    #   type :config_source_map, Yarrow::Schema::Types::Instance.of(Hash).accept(Symbol)
    # end
    # class PolicySpec < Yarrow::Schema::Entity[:__config_policy_spec]
    #   attribute :module, :string
    #   attribute :source_map, :__config_source_map
    # end

    # Yarrow::Schema::Definitions.register(
    #   :__config_source_map,
    #   Yarrow::Schema::Types::Map.of(Symbol)
    # )
    class Content < Yarrow::Schema::Entity
      attribute :module, :string
      #attribute :source_map, :__config_source_map
      attribute :source_map, :hash
    end
    
    # Template engine and site generator configuration block
    class OutputGenerator < Yarrow::Schema::Entity
      attribute :engine, :string
      attribute :template_dir, :string
      attribute :options, :hash
    end

    # Document mapping configuration block
    class OutputManifest < Yarrow::Schema::Entity
      attribute :layout, :string
      attribute :scheme, :string
    end

    # Define output document map type
    Yarrow::Schema::Definitions.register(
      :yarrow_config_output_manifest_spec,
      Yarrow::Schema::Types::Map.of(Symbol => OutputManifest).accept_elements(Hash)
    )

    # Manifest reconciliation configuration block
    class OutputReconcile < Yarrow::Schema::Entity
      attribute :match, :string
      attribute :manifest, :yarrow_config_output_manifest_spec
    end

    # Output configuration block
    class Output < Yarrow::Schema::Entity
      attribute :target, :string
      attribute :generator, :yarrow_config_output_generator
      attribute :reconcile, :yarrow_config_output_reconcile
    end

    # Define output schema list type
    Yarrow::Schema::Definitions.register(
      :yarrow_config_output_list,
      Yarrow::Schema::Types::List.of(Output).accept_elements(Hash)
    )

    # Top level root config namespace.
    class Instance < Yarrow::Schema::Entity
      attribute :source_dir, :path
      attribute :output_dir, :path
      attribute :meta, :yarrow_config_meta
      attribute :server, :any
      attribute :content, :yarrow_config_content
      attribute :output, :yarrow_config_output_list
      #attribute :output, :any
    end
    #
    # `content_dir` and `output_dir` are placeholders and should be overriden
    # with more fine-grained config for web and book outputs in future.
    #
    # Additional server config is optional and only needed if running the dev
    # server locally.
    #
    # TODO: meta should be union of Type::Optional and Config::Meta
    # Instance = Yarrow::Schema::Value.new(
    #   project_dir: :path,
    #   content_dir: :path,
    #   output_dir: :path,
    #   meta: :any,
    #   server: :any
    # )
  end
end
