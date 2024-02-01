require "yarrow/configuration/instance"
require "yarrow/configuration/content"
require "yarrow/configuration/expansion_policy"

module Yarrow
  module Configuration
    def self.load(path)
      config_doc = KDL.parse_document(File.read(path))
      Instance.from_doc(config_doc)
    end
  end

  # Raised when a required config section or property is missing.
  class ConfigurationError < StandardError
    def self.missing_section(name)
      new("Missing config section #{name.to_sym}")
    end
  end
end
