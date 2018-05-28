module Huyegger
  module Middlewares
    class Rails
      def initialize(app)
        @app = app
      end

      def call(env)
        store_context!

        @app.call(env)
      ensure
        clear_context!
      end

      private

      def store_context!
        return unless ::Rails.logger.is_a?(Huyegger::Logger)

        ::Rails.logger.context(rails_env: Rails.env.to_s)
      end

      def clear_context!
        ::Rails.logger.clear_context! if ::Rails.logger.is_a?(Huyegger::Logger)
      end
    end
  end
end
