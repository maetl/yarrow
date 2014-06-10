module Yarrow

  # Generates documentation from a model.
  #
  # Subclasses of Generator need to override the template methods,
  # to specify a particular file structure to output.
  class Generator
  
    def initialize(target, site_tree)
      ensure_dir_exists! target
      @target = target
      @site_tree = site_tree
    end
  
    def ensure_dir_exists!(target)
      unless File.directory? target
        Dir.mkdir target
      end
    end
    
    def build_docs
      
    end
  
  end

end