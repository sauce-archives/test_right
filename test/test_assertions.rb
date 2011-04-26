require 'helper'

class TestAssertions < Test::Unit::TestCase
  def test_assert
    assert_raises Test::Right::AssertionFailedError do
      x = Object.new
      x.send(:extend, Test::Right::Assertions)
      x.assert(1) {
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
end
