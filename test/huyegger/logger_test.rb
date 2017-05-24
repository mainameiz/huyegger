require "test_helper"
require "json"

class Huyegger::LoggerTest < Minitest::Test
  def setup
    @io = StringIO.new
    @logger = Logger.new(@io)
    @logger.level = Logger::DEBUG
    @huyegger = Huyegger::Logger.new(@logger)
  end

  def output
    @io.string
  end

  def test_logger
    assert_respond_to(@huyegger, :context)
    assert_respond_to(@huyegger, :purge_context!)
  end

  def test_output
    @huyegger.info("test")
    assert_equal(output, { level: "INFO", message: "test" }.to_json)
  end

  def test_level
    @logger.level = Logger::FATAL
    @huyegger.info("test")
    assert_equal(output, "")
  end

  def test_context
    @huyegger.context(meta: "metadata")
    @huyegger.info("test")
    assert_equal(output, { level: "INFO", meta: "metadata", message: "test" }.to_json)
  end
end
