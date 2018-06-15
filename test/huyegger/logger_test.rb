require "test_helper"
require "json"
require "timecop"

class Huyegger::LoggerTest < Minitest::Test
  def setup
    @io = StringIO.new
    @logger = Logger.new(@io)
    @logger.level = Logger::DEBUG
    @huyegger = Huyegger::Logger.new(@logger)
    @time = Timecop.freeze
  end

  def teardown
    Timecop.return
  end

  def output
    @io.string.chomp
  end

  def test_logger
    assert_respond_to(@huyegger, :context)
    assert_respond_to(@huyegger, :clear_context!)
  end

  def test_output
    @huyegger.info("test")
    assert_equal(output, { level: "INFO", message: "test", timestamp: @time.xmlschema }.to_json)
  end

  def test_message_key
    @huyegger.info(message: "log message")
    assert_equal(output, { level: "INFO", message: "log message", timestamp: @time.xmlschema }.to_json)
  end

  def test_level
    @logger.level = Logger::FATAL
    @huyegger.info("test")
    assert_equal(output, "")
  end

  def test_context
    @huyegger.context(meta: "metadata")
    @huyegger.info("test")
    assert_equal(output, { level: "INFO", meta: "metadata", message: "test", timestamp: @time.xmlschema }.to_json)
  end
end
