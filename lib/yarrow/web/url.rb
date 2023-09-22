module Yarrow
  module Web
    module URI
    end

    class URL
      def self.generate(resource)
        path = if resource.respond_to?(:url)
          resource.url
        elsif resource.respond_to?(:permalink)
          resource.permalink
        else
          # TODO: URL generation strategy
          "/one/two/three"
        end

        new(path)
      end

      def initialize(path)
        @path = path
      end

      def to_s
        @path
      end
    end
  end
end