require 'helper'

class TestAssertions < Test::Unit::TestCase
  def setup
    @assertable = Object.new
    @assertable.send(:extend, Test::Right::Assertions)
  end

  def test_assert
    assert_raises Test::Right::AssertionFailedError do
      x = Object.new
      x.send(:extend, Test::Right::Assertions)
      x.assert(0.1) {
        false
      }
    end

    assert_nothing_raised do
      x = Object.new
      x.send(:extend, Test::Right::Assertions)
      x.assert {
        true
      }
    end
  end

  def test_spinassert
    assert_nothing_raised do
      x = Object.new
      y = false
      x.send(:extend, Test::Right::Assertions)
      t = Thread.new do
        sleep(1)
        y = true
      end
      x.assert {
        y
      }
    end

    assert_raises Test::Right::AssertionFailedError do
      x = Object.new
      y = false
      x.send(:extend, Test::Right::Assertions)
      x.assert(1) {
        y
      }
    end
  end

  def test_assert_equal
    assert_nothing_raised do
      @assertable.assert_equal 1, 1
    end
    assert_raises Test::Right::AssertionFailedError do
      @assertable.assert_equal 1, 2
    end
  end

  def test_assert_equal_on_value
    x = 1
    v = Test::Right::Value.new do
      x
    end

    Thread.new do
      sleep 0.5
      x = 2
    end

    assert_nothing_raised do
      @assertable.assert_equal 1, v
    end
  end
end
