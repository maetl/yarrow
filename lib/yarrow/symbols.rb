require "strings-inflection"
require "strings-case"

module Yarrow
  module Symbols
    # @param [Array<String>, Array<Symbol>] parts
    # @return [Object]
    def self.to_module_const(parts)
      Object.const_get(parts.map { |atom|
        Strings::Case.pascalcase(atom.to_s)
      }.join("::"))
    end

    # Converts an atomic content identifier to a live class constant.
    #
    # @param [Symbol, String] atom
    # @return [Object]
    def self.to_const(atom)
      Object.const_get(Strings::Case.pascalcase(atom.to_s).to_sym)
    end

    # @param [Symbol, String] atom
    # @return [Symbol]
    def self.to_singular(atom)
      Strings::Inflection.singularize(atom.to_s).to_sym
    end

    # @param [Symbol, String] atom
    # @return [Symbol]
    def self.to_plural(atom)
      Strings::Inflection.pluralize(atom.to_s).to_sym
    end
  end
end
