module Yarrow
  module Output

    ##
    # Provides a data context for rendering a template.
    #
    # Methods provided by this class become available as named variables in Mustache templates.
    # 
    # Includes the library of helpers for dynamically generating HTML tags.
    #
    class Context

      include Yarrow::HTML::AssetTags

      def initialize(attributes)
        metaclass = class << self; self; end
        attributes.each do |name, value|
          metaclass.send :define_method, name, lambda { value }
        end
      end
    end

  end
end
