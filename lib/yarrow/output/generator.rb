module Yarrow
  module Output
    # Generates documentation from an object model.
    class Generator
      def initialize(config={})
        @config = config
      end

      # Mapping between template types and provided object model
      def object_map
        @config.output.object_map
      end

      # Mapping between template types and provided output templates.
      def template_map
        
      end

      # Template converter used by this generator instance.
      def converter

      end

      def write_output_file(filename, content)
      end

      # Builds the output documentation.
      def build_docs
        object_map.each do |index, objects|
          objects.each do |object|
            template_context = {
              #:meta => Site
              index => object
            }
            content = converter.render(template_map[index], template_context)
            filename = converter.filename_for(object)
            write_output_file(filename, content)
          end
        end
      end
    end
  end
end
