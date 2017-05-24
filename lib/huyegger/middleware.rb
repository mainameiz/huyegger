module Huyegger
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    ensure
      Rails.logger.purge_context! if Rails.logger.is_a?(Huyegger::Logger)
    end
  end
end
