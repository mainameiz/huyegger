module Huyegger
  class Railtie < ::Rails::Railtie
    initializer "huyegger.insert_middleware" do |app|
      if ActionDispatch.const_defined? :RequestId
        app.config.middleware.insert_after ActionDispatch::RequestId, Huyegger::Middleware
      else
        app.config.middleware.insert_after Rack::MethodOverride, Huyegger::Middleware
      end

      if ActiveSupport.const_defined?(:Reloader) && ActiveSupport::Reloader.respond_to?(:to_complete)
        ActiveSupport::Reloader.to_complete do
          Rails.logger.purge_context! if Rails.logger.is_a?(Huyegger::Logger)
        end
      elsif ActionDispatch.const_defined?(:Reloader) && ActionDispatch::Reloader.respond_to?(:to_cleanup)
        ActionDispatch::Reloader.to_cleanup do
          Rails.logger.purge_context! if Rails.logger.is_a?(Huyegger::Logger)
        end
      end
    end
  end
end
