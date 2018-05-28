module Huyegger
  module Middlewares
    class Sidekiq
      def call(worker, item, queue)
        store_context!(worker, item, queue)

        yield
      ensure
        clear_context!
      end

      def store_context!(worker, item, queue)
        return unless ::Rails.logger.is_a?(Huyegger::Logger)

        ::Rails.logger.context(
          sidekiq: {
            worker: worker.class.to_s,
            queue: queue,
            jid: item['jid'],
            args: item['args']
          }
        )
      end

      def clear_context!
        ::Rails.logger.clear_context! if ::Rails.logger.is_a?(Huyegger::Logger)
      end
    end
  end
end
