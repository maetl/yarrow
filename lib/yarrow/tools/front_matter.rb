module Yarrow
  module Tools
    module FrontMatter

      def read_split_content(path, options={})
        extract_split_content(File.read(path, :encoding => 'utf-8'), options)
      end

      def extract_split_content(text, options={})
        pattern = /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
        if text =~ pattern
          content = text.sub(pattern, "")

          begin
            if options.key?(:symbolize_keys)
              meta = symbolize_keys(YAML.load($1))
            else
              meta = YAML.load($1)
            end
            return [content, meta]
          rescue Psych::SyntaxError => error
            if defined? ::Logger
              # todo: application wide logger
              logger = ::Logger.new(STDOUT)
              logger.error "#{error.message}"
            end
            return [content, nil]
          end
        end

        [text, nil]
      end

      def symbolize_keys(hash)
        hash.inject({}) do |result, (key, value)|
          new_key = case key
                    when String then key.to_sym
                    else key
                    end
          new_value = case value
                      when Hash then symbolize_keys(value)
                      when Array then value.map { |entry| symbolize_keys(entry) }
                      else value
                      end
          result[new_key] = new_value
          result
        end
      end
    end
  end
end
