require "huyegger/formatter"

module Huyegger
  module Logger
    def context(*args)
      formatter.context(*args)
    end

    def purge_context!
      formatter.clear_context!
    end

    def self.new(logger)
      logger.formatter = Huyegger::Formatter.new(logger.formatter)
      logger.extend(self)
    end
  end
end
