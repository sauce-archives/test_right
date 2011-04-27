require 'helper'

class TestValue < Test::Unit::TestCase
  include Test::Right::Assertions

  def test_reevaluates
    x = "foo"

    v = Test::Right::Value.new do
      x
    end

    assert_equal "foo", v

    x = "bar"

    assert_equal "bar", v
  end
end
