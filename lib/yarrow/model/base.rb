require "mementus"
require "active_support/inflector"

module Yarrow
  module Model
    class Base < Mementus::Model
      def self.inherited(klass)
        self.superclass.inherited(klass)
        Index.register(klass)
      end
    end
  end
end
