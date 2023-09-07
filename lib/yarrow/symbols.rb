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

    # Converts a string name of class const to a symbol atom
    #
    # @param [Class, String, #to_s] const_obj
    # @return [Symbol]
    def self.from_const(const_obj)
      const_lookup = if const_obj.respond_to?(:name)
        const_obj.name
      else
        const_obj.to_s
      end

      Strings::Case.underscore(const_lookup).to_sym
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

    # @param [Symbol, String] atom
    # @return [String]
    def self.to_text(identifier)
      identifier.to_s.gsub(/\A[^[:alnum:]]+/, "").gsub(/[\-_]+/, " ").capitalize
    end
  end
end
