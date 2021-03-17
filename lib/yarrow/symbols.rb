require "strings-inflection"
require "strings-case"

module Yarrow
  module Symbols
    # Converts an atomic content identifier to a live class constant.
    def self.to_const(atom)
      Object.const_get(Strings::Case.pascalcase(atom.to_s).to_sym)
    end

    def self.to_singular(atom)
      Strings::Inflection.singularize(atom.to_s).to_sym
    end

    def self.to_plural(atom)
      Strings::Inflection.pluralize(atom.to_s).to_sym
    end
  end
end
