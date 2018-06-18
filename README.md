# Huyegger

This is JSON Logger (Huyegger) for ruby.

## Installation

```ruby
gem install hyegger

gem "huyegger"
```

## Usage

```ruby
# require "json" # to use default json encoder (see below)

file_logger = Logger.new("/var/log/your_progname.log")
logger = Huyegger::Logger.new(file_logger)

# or better
# require "syslog/logger"
syslog_logger = Syslog::Logger.new("your_progname")
logger = Huyegger::Logger.new(syslog_logger)

# Write messages:
logger.info "log message"
# => { "level": "INFO", "message": "log message", timestamp: "2018-06-18T11:45:54+03:00" }
logger.info { "http.host" => "127.0.0.1", message: "log message" }
# => { "level": "INFO", "message": "log message", "http.host": "127.0.0.1", timestamp: "2018-06-18T11:45:54+03:00" }

# Store context for all log messages, it will be merged to resulting messages
logger.context("http.host" => "127.0.0.1")
logger.info("log message")
# => { "level": "INFO", "message": "log message", "http.host": "127.0.0.1", timestamp: "2018-06-18T11:45:54+03:00" }

# Remove context
logger.purge_context!

# Configure json encoder
Huyegger.json_encoder = proc { |obj| Oj.dump(obj, mode: :compat) }

# Default implementation of json_encoder uses `Object#to_json`,
# but you need to `require "json"` to use default json encoder.
```

To use with Rails

```ruby
# inside config/enviroments/production.rb
require "huyegger/railtie"

# inside app/controller/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :set_context

  ...

  def set_context
    Rails.logger.context(
      "http.host" => request.host,
      "http.method" => request.request_method,
      "http.path" => request.path,
      "http.addr" => request.remote_ip
    ) if Rails.logger.respond_to?(:context)
  end
end
```

To use with Sidekiq

```ruby
# inside config/initializers/sidekiq.rb

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Huyegger::Middlewares::Sidekiq
  end
end
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mainameiz/huyegger.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
