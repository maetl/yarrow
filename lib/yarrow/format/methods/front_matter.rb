module Yarrow
  module Format
    module Methods
      # Utility methods for working with text formats containing frontmatter separators.
      module FrontMatter
        module Syntax
          YAML = "-"
          YAML_DOC_END = "."
          TOML = "+"
          MM_JSON = ";"
          JSON_START = "{"
          JSON_END = "}"

          PATTERN = /\A
            (?<start>[\-]{3}|[\+]{3}|[;]{3}|[\{]{1})\s*\r?\n
            (?<meta>.*?)\r?\n?
            ^(?<stop>[\-]{3}|[\+]{3}|[;]{3}|[\.]{3}|[\}]{1})\s*\r?\n?
            \r?\n?
            (?<body>.*)
          /mx
        end

        module ClassMethods
          def read(path)
            text = File.read(path, :encoding => "utf-8")
            source, metadata = parse(text)
            Yarrow::Format::Contents.new(new(source), metadata)
          end

          def parse(text)
            result = Syntax::PATTERN.match(text)

            return [text, nil] if result.nil?

            start_chr = result[:start].chr
            stop_chr = result[:stop].chr
            input = result[:meta]

            meta = if start_chr == stop_chr
              case start_chr
              when Syntax::YAML then parse_yaml(input)
              when Syntax::TOML then parse_toml(input)
              when Syntax::MM_JSON then parse_json(input)
              end
            else
              if start_chr == Syntax::YAML && stop_chr == Syntax::YAML_DOC_END
                parse_yaml(input)
              elsif start_chr == Syntax::JSON_START && stop_chr == Syntax::JSON_END
                parse_json(input)
              else
                raise "Unsupported frontmatter delimiters"
              end
            end

            [result[:body], meta]
          end

          def parse_yaml(raw)
            YAML.load(raw, symbolize_names: true)
          end

          def parse_toml(raw)
            TOML::Parser.new(raw).parsed
          end

          def parse_json(raw)
            JSON.parse("{#{raw}}", symbolize_names: true)
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
