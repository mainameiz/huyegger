# frozen_string_literal: true
require "logger"

module Huyegger
  class Formatter
    SEVERITY_STR = {
      ::Logger::DEBUG => 'DEBUG',
      ::Logger::INFO => 'INFO',
      ::Logger::WARN => 'WARN',
      ::Logger::ERROR => 'ERROR',
      ::Logger::FATAL => 'FATAL',
      ::Logger::UNKNOWN => 'UNKNOWN'
    }

    attr_reader :original_formatter

    def initialize(original_formatter)
      @original_formatter = original_formatter
    end

    def purge_context!
      __context__.clear
    end

    def context(context)
      __context__.merge!(context) unless context.nil?
    end

    # This method is invoked when a log event occurs
    def call(severity, timestamp, progname, msg)
      msg = original_formatter.call(severity, timestamp, progname, msg) if original_formatter && String === msg
      json_message = {}

      add_severity!(json_message, severity)
      json_message.merge!(__context__)
      add_message!(json_message, msg)

      Huyegger.json_encoder.call(json_message)
    end

    private

    def add_severity!(json_message, severity)
      case severity
      when String
        json_message.merge!('level' => severity)
      when Integer
        json_message.merge!('level' => SEVERITY_STR.fetch(severity))
      else
        json_message.merge!('level' => SEVERITY_STR.fetch(::Logger::UNKNOWN))
      end
    end

    def add_message!(json_message, msg)
      case msg
      when String
        json_message.merge!('message' => msg)
      when Hash
        json_message.merge!('message' => 'Empty message') # default message because it is required
        json_message.merge!(msg)
      else
        json_message.merge!('message' => msg.inspect)
      end
    end

    def __context__
      # Use object_id to avoid conflicts with other instances
      Thread.current[:"__huyegger_context__#{object_id}"] ||= {}
    end
  end
end
