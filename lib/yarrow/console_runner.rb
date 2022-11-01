module Yarrow
  class ConsoleRunner
    SUCCESS = 0
    FAILURE = 1

    ENABLED_OPTIONS = {
      :h => :help,
      :v => :version,
      :c => :config,
      :t => :theme,
    }

    ALLOWED_CONFIG_FILES = [
      ".yarrowdoc",
      "Yarrowdoc",
      "yarrow.yml"
    ]

    def initialize(args, io=STDOUT)
      @arguments = args
      @out = io
      @options = {}
      @targets = []
    end

    def config
      @config ||= Configuration.load_defaults
    end

    def run_application
      print_header

      begin
        process_arguments

        if has_option?(:version)
          return SUCCESS
        end

        if has_option?(:help)
          print_help
          return SUCCESS
        end

        process_configuration

        run_generation_process

        print_footer

        SUCCESS
      rescue Exception => e
        print_error e
        FAILURE
      end
    end

    def process_arguments
      @arguments.each do |arg|
        if is_option?(arg)
          register_option(arg)
        else
          @targets << arg
        end
      end
    end

    # def load_configuration(path)
    #   ALLOWED_CONFIG_FILES.each do |filename|
    #     config_path = path + '/' + filename
    #     if File.exists? config_path
    #       @config.deep_merge! Configuration.load(config_path)
    #       return
    #     end
    #   end
    # end

    def process_configuration
      # load_configuration(Dir.pwd)
      default_config = Yarrow::Configuration.load_defaults

      if @targets.empty?
        @config = default_config
      else
        @config = Yarrow::Config::Instance.new(
          output_dir: default_config.output_dir,
          source_dir: @targets.first,
          meta: default_config.meta,
          server: default_config.meta
        )
      end

      # @targets.each do |input_path|
      #   @config.deep_merge! load_configuration(input_path)
      # end

      # if has_option?(:config)
      #   path = @options[:config]
      #   @config.deep_merge! Configuration.load(path)
      # end

      #@config.options = @options.to_hash

      # normalize_theme_path

      # theme = @config.options.theme
      # @config.append load_configuration(theme)
    end

    def normalize_theme_path
      # noop
    end

    def register_option(raw_option)
      option = raw_option.gsub(":", "=")
      if option.include? "="
        parts = option.split("=")
        option = parts[0]
        value = parts[1]
      else
        value = true
      end

      name = option.gsub("-", "")

      if option[0..1] == "--"
        if ENABLED_OPTIONS.has_value?(name.to_sym)
          @options[name.to_sym] = value
          return
        end
      else
        if ENABLED_OPTIONS.has_key?(name.to_sym)
          @options[ENABLED_OPTIONS[name.to_sym]] = value
          return
        end
      end

      raise "Unrecognized option: #{raw_option}"
    end

    def is_option?(argument)
      argument[0] == "-"
    end

    def has_option?(option)
      @options.has_key? option
    end

    def run_generation_process
      generator = Generator.new(@config)
      generator.generate
    end

    def print_header
      @out.puts Yarrow::APP_NAME + " " + Yarrow::VERSION
    end

    def print_footer
      @out.puts "Content generated at #{@config.output_dir}"
    end

    def print_error(e)
      @out.puts "Error! " + e.to_s
    end

    def print_help
      help_path = Pathname.new(__dir__) + "help.txt"
      @out.puts(help_path.read)
    end
  end
end
