$LOAD_PATH.unshift File.expand_path("../yarrow/lib", __dir__)
require "yarrow"

module BuildASite
  module Model
    class Articles
      def initialize(collection)
        puts collection
      end
    end

    class Article
      def initialize(entity)
        puts entity
      end
    end
  end
end

web_output = {
  target: "web",
  generator: {
    engine: "liquid",
    template_dir: "./templates",
    options: {}
  },
  reconcile: {
    match: "collection",
    manifest: {
      articles: {
        layout: "articles",
        scheme: "/{ancestor_path}"
      },
      article: {
        layout: "article",
        scheme: "/{ancestor_path}/{name}"
      }
    }
  }
}

config = Yarrow::Config::Instance.new({
  source_dir: "./content",
  output_dir: "./web",
  meta: {
    title: "Build-a-Site",
    author: "maetl-test"
  },
  server: {},
  content: {
    module: "BuildASite::Model",
    source_map: { root: { container: :articles, entity: :article }}
  },
  output: [web_output]
})

generator = Yarrow::Generator.new(config)
generator.generate