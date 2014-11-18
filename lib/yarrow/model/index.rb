require "active_support/inflector"

module Yarrow
  module Model
    class Index
      def self.register(klass)
        method_name = ActiveSupport::Inflector.pluralize(ActiveSupport::Inflector.underscore(klass.to_s)).to_sym
        puts method_name
        define_singleton_method method_name, lambda { klass.all }
      end
    end
  end
end
