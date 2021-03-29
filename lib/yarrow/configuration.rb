module Yarrow
  class Configuration
    class << self
      # Merges the given configuration or hash-like object with the
      # registered global configuration.
      #
      # @param [Hash, Hashie::Mash, Yarrow::Configuration]
      #
      def merge(config)
        instance.deep_merge!(config)
      end

      # Loads a configuration object from the given YAML file.
      #
      # @param [String] path to YAML file
      #
      # @return [Yarrow::Config]
      #
      def load(file)
        coerce_config_struct(YAML.load(File.read(file), symbolize_names: true))
      end

      # Yarrow is distributed with a `defaults.yml` which provides minimum
      # boostrap configuration and default settings for various internal
      # classes. Use this method to automatically load these defaults.
      #
      # @return [Yarrow::Configuration]
      def load_defaults
        load(File.join(File.dirname(__FILE__), 'defaults.yml'))
      end

      private

      # TODO: this should be folded into the schema machinery with type coercions
      def coerce_config_struct(config)
        meta_obj = if config.key?(:meta)
          Yarrow::Config::Meta.new(
            title: config[:meta][:title],
            author: config[:meta][:author]
          )
        else
          nil
        end

        server_obj = if config.key?(:server)
          Yarrow::Config::Server.new(**config[:server])
        else
          nil
        end

        # TODO: messy hack to get rid of Hashie::Mash, this should either be
        # automated as part of the schema types or a default value should be
        # generated here (eg: `"#{Dir.pwd}/docs"`)
        out_dir_or_string = config[:output_dir] || ""
        source_dir_or_string = config[:source] || ""
        content_dir_or_string = config[:content] || ""

        Yarrow::Config::Instance.new(
          output_dir: Pathname.new(File.expand_path(out_dir_or_string)),
          source: Pathname.new(File.expand_path(source_dir_or_string)),
          content: Pathname.new(File.expand_path(content_dir_or_string)),
          meta: meta_obj,
          server: server_obj
        )
      end
    end
  end

  ##
  # Raised when a required config section or property is missing.
  class ConfigurationError < StandardError
  end
end
