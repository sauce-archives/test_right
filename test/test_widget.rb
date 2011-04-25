require 'helper'

class TestWidget < Test::Unit::TestCase
  def setup
    eval <<-CLASSDEFS
    class SimpleWidget < Test::Right::Widget
    end
    CLASSDEFS
  end

  def teardown
    Test::Right::Widget.wipe!
    Test::Right::Feature.wipe!
  end

  def test_raises_when_action_not_implemented
    assert_raises Test::Right::WidgetActionNotImplemented do
      SimpleWidget.new(nil, nil).fail_action
    end
  end

  def test_raises_helpfully
    begin
      SimpleWidget.new(nil, nil).fail_action
    rescue Test::Right::WidgetActionNotImplemented => e
      assert e.message.include?("SimpleWidget"), e.message
      assert e.message.include?("fail_action"), e.message
    end
  end

  def test_fill_in
    begin
      eval <<-CLASSDEFS
      class WidgetWithField < Test::Right::Widget
        def fill
          fill_in :foo, "bar"
        end
      end
      CLASSDEFS

      mock_driver = MockDriver.new
      WidgetWithField.new(mock_driver, nil).fill
    ensure
      Test::Right::Widget.wipe!
    end
  end
end
