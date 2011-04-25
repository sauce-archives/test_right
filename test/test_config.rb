require 'helper'

class TestConfig < Test::Unit::TestCase
  def test_access
    c = Test::Right::Config.new({'foo' => 1})

    assert_equal 1, c['foo']
    assert_equal 1, c[:foo]
  end
end
