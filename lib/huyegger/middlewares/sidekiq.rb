module Huyegger
  module Middlewares
    class Sidekiq
      def call(worker, msg, queue)
        ::Rails.logger.purge_context! if defined?(Huyegger) && ::Rails.logger.is_a?(Huyegger::Logger)
        yield
      end
    end
  end
end
