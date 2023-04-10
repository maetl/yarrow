module Yarrow
  module Format
    module Methods
      # Utility methods for working with text formats containing frontmatter separators.
      module FrontMatter
        module ClassMethods
          def read(path)
            text = File.read(path, :encoding => "utf-8")
            source, metadata = read_yfm(path)
            Yarrow::Format::Contents.new(new(source), metadata)
          end

          def read_yfm(path)
            text = File.read(path, :encoding => 'utf-8')
            extract_yfm(text, symbolize_keys: true)
          end
  
          def extract_yfm(text, options={})
            pattern = /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
            if text =~ pattern
              content = text.sub(pattern, "")
  
              begin
                if options.key?(:symbolize_keys)
                  meta = YAML.load($1, symbolize_names: true)
                else
                  meta = YAML.load($1)
                end
                return [content, meta]
              rescue Psych::SyntaxError => error
                if defined? ::Logger
                  # todo: application wide logger
                  #logger = ::Logger.new(STDOUT)
                  #logger.error "#{error.message}"
                end
                return [content, nil]
              end
            end
  
            [text, nil]
          end
  
          def write_yfm(name, text, meta)
            # Symbolized keys are better to deal with when manipulating data in
            # Ruby but are an interop nightmare when serialized so here we do a
            # round-trip through JSON encoding to ensure all keys are string
            # encoded before dumping them to the front matter format.
            File.write(name, [YAML.dump(meta.to_json), "---", text].join("\n"))
          end
        end

        def self.included(base)
          base.extend(ClassMethods)
        end
      end
    end
  end
end
