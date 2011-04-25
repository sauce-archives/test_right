require 'helper'

class TestWidget < Test::Unit::TestCase
  def setup
    eval <<-CLASSDEFS
    class SimpleWidget < Test::Right::Widget
    end

    class WidgetThatDoesThings < Test::Right::Widget
      def fill
        fill_in :foo, "bar"
      end

      def clickit
        click :foo
      end

      def go_to_google
        navigate_to "http://www.google.com"
      end

      def frob
        get_element(:frobbable).frob
      end

      def frob_nonexistant
        get_element(:not_frobbable).frob
      end
    end
    CLASSDEFS
    
    @widget_selectors = Test::Right::SelectorLibrary::Widget.new
    @widget_selectors.instance_eval do
      @selectors = {:foo => {:id => 'foo'}, :frobbable => {:id => 'f'}}

      lives_at "/foo/bar"
    end
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
      raise "Shouldn't have gotten to this point"
    rescue Test::Right::WidgetActionNotImplemented => e
      assert e.message.include?("SimpleWidget"), e.message
      assert e.message.include?("fail_action"), e.message
    end
  end

  def test_fill_in
    mock_driver = MockDriver.new
    element = MockElement.new

    mock_driver.expects(:find_element).with(:id, 'foo').returns(element)
    element.expects(:send_keys).with('bar')

    WidgetThatDoesThings.new(mock_driver, @widget_selectors).fill
  end

  def test_click
    mock_driver = MockDriver.new
    element = MockElement.new

    mock_driver.expects(:find_element).with(:id, 'foo').returns(element)
    element.expects(:click)

    WidgetThatDoesThings.new(mock_driver, @widget_selectors).clickit
  end

  def test_navigate_to
    mock_driver = MockDriver.new

    mock_driver.expects(:get).with("http://www.google.com")

    WidgetThatDoesThings.new(mock_driver, @widget_selectors).go_to_google
  end

  def test_lives_at
    mock_driver = MockDriver.new
    mock_driver.expects(:get).with("/foo/bar", :relative => true)

    WidgetThatDoesThings.new(mock_driver, @widget_selectors).visit
  end

  def test_get_element
    mock_element = mock()
    mock_element.expects(:frob)
    mock_driver = MockDriver.new
    mock_driver.expects(:find_element).with(:id, 'f').returns(mock_element)
    assert_nothing_raised do
      WidgetThatDoesThings.new(mock_driver, @widget_selectors).frob
    end

    assert_raises Test::Right::SelectorNotFoundError do
      WidgetThatDoesThings.new(mock_driver, @widget_selectors).frob_nonexistant
    end
  end
end
