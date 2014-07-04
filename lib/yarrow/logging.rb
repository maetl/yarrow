require 'logger'

module Yarrow

  module Logging
    class NullLogger < ::Logger
      def initialize(*args)
      end

      def add(*args, &block)
      end
    end
  end

  class << self

    def logger
      @logger ||= create_logger
    end

    def logger=(logger)
      @logger = logger
    end

    private

    def create_logger
      Logging::NullLogger.new
    end

  end

  module Loggable

    def logger
      Yarrow.logger
    end

  end

end
