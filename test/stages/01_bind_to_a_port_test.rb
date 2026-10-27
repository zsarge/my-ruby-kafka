require_relative "../test_helper"

class BindToAPortTest < Minitest::Test
  def setup
    @broker = BrokerProcess.new
    @broker.start
  end

  def teardown
    @broker.stop
  end

  def test_listens_on_kafkas_default_port
    assert @broker.wait_until_listening
  end
end
