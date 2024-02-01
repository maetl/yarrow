def load_content_graph(fixture_ref, policy_spec)
  content_graph = Yarrow::Content::Source.collect(fixture_ref)
  policy = Yarrow::Content::Policy.from_spec(:build_pages)
  traversal = Yarrow::Content::Expansion::Traversal.new(content_graph, policy)
  traversal.expand
  p content_graph
  content_graph
end

describe Yarrow::Output::Build do
  describe "sources/doctest" do
    class BuildPages
      def initialize(attrs)
        @attrs = attrs
      end
    end

    class BuildPage
      def initialize(attrs)
        @attrs = attrs
      end
    end

    let :graph do
      load_content_graph(fixture_path(self.class.description), :build_pages)
    end

    # let :output_config do
    #   Yarrow::Config::Output.new(
    #     target: "web",
    #     generator: {
    #       engine: "liquid",
    #       template_dir: "templates",
    #       options: {
    #         error_mode: "strict"
    #       }
    #     },
    #     reconcile: {
    #       match: "collection/resource",
    #       manifest: {
    #         build_page: {
    #           layout: "collection",
    #           scheme: "/{ancestors*}"
    #         }
    #       }
    #     }
    #   )
    # end

    it "reconciles manifest from fixture" do
      output_config = double()
      reconcile_config = double()
      manifest_config = {
        build_page: {
          layout: "collection",
          scheme: "/{ancestors*}"
        }
      }

      allow(output_config).to receive(:reconcile) { reconcile_config }
      allow(reconcile_config).to receive(:match) { "collection/resource" }
      allow(reconcile_config).to receive(:manifest) { manifest_config }

      build = Yarrow::Output::Build.new(graph, output_config)
      build.reconcile
    end
  end
end