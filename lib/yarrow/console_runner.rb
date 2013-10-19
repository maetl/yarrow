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
      '.yarrowdoc',
      'Yarrowdoc'
    ]
    
    def initialize(arguments, io=STDOUT)
      @out = io
      @arguments = arguments
      @options = {}
      @targets = []
      @config = Configuration.load(File.dirname(__FILE__) + "/defaults.yml")
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
        
        run_input_process
        
        run_output_process
        
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
    
    def load_configuration(path)
      ALLOWED_CONFIG_FILES.each do |filename|
        config_path = path + '/' + filename
        if File.exists? config_path
          return RecursiveOpenStruct.new(YAML.load_file(config_path))
        end
      end
    end
    
    def process_configuration
      @config.merge load_configuration(Dir.pwd)
      
      @config.input_targets.each do |input_path|
        @config.merge load_configuration(input_path)
      end
      
      if has_option?(:config)
        path = @options[:config]
        @config.merge Load.config(path)
      end
      
      @config.merge({ :options => @options })
      
      normalize_theme_path
      
      theme = @config.options.theme
      @config.append load_configuration(theme)
    end
    
    def normalize_theme_path
      
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
    
    def run_input_process
      
    end
    
    def run_output_process
      
    end
    
    def print_header
      @out.puts Yarrow::APP_NAME + " " + Yarrow::VERSION
    end
    
    def print_footer
      @out.puts "Documenation generated at {path}!"
    end
    
    def print_error(e)
      @out.puts "Error! " + e.to_s
    end
    
    def print_help
      help = <<HELP
  See http://yarrowdoc.org for more information.

  Usage:

   $ yarrow [options]
   $ yarrow [options] <input>
   $ yarrow [options] <input input> <output>

   Arguments

   <input>  -  Path to source directory or an individual source file. If not supplied
               defaults to the current working directory. Multiple directories
               can be specified by repeating arguments, separated by whitespace.

   <output> -  Path to the generated documentation. If not supplied, defaults to
               ./docs in the current working directory. If it does not exist, it
               is created. If it does exist it remains in place, but existing
               files are overwritten by new files with the same name.

   Options

   Use -o or --option for boolean switches and --option=value or --option:value
   for options that require an explicit value to be set.

    -h    --help          [switch]    Display this help message and exit
    -v    --version       [switch]    Display version header and exit
    -c    --config        [string]    Path to a config properties file
    -p    --packages   	  [string]    Defines package convention for the model
    -t    --theme         [string]    Template theme for generated docs


HELP
      @out.puts help
    end

  end

end