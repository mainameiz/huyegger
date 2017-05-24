module Huyegger
  module Middlewares
    class Rails
      def initialize(app)
        @app = app
      end

      def call(env)
        @app.call(env)
      ensure
        ::Rails.logger.purge_context! if defined?(Huyegger) && ::Rails.logger.is_a?(Huyegger::Logger)
      end
    end
  end
end
