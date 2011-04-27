require 'helper'

class TestWidget < Test::Unit::TestCase
  def setup
    eval <<-CLASSDEFS
    class SimpleWidget < Test::Right::Widget
    end

    class WidgetThatDoesThings < Test::Right::Widget
      field :foo, :id => 'foo'
      element :frobbable, :id => 'f'
      element :foos, :css => '.foo'

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

      def get_foos
        get_elements(:foos)
      end
    end
    CLASSDEFS
    
    @driver = MockDriver.new
    @widget = WidgetThatDoesThings.new(@driver)
  end

  def teardown
    Test::Right::Widget.wipe!
    Test::Right::Feature.wipe!
  end

  def test_raises_when_action_not_implemented
    assert_raises Test::Right::WidgetActionNotImplemented do
      SimpleWidget.new(nil).fail_action
    end
  end

  def test_raises_helpfully
    begin
      SimpleWidget.new(nil).fail_action
      raise "Shouldn't have gotten to this point"
    rescue Test::Right::WidgetActionNotImplemented => e
      assert e.message.include?("SimpleWidget"), e.message
      assert e.message.include?("fail_action"), e.message
    end
  end

  def test_fill_in
    element = MockElement.new

    @driver.expects(:find_element).with(:id, 'foo').returns(element)
    element.expects(:send_keys).with('bar')

    @widget.fill
  end

  def test_click
    element = MockElement.new

    @driver.expects(:find_element).with(:id, 'foo').returns(element)
    element.expects(:click)

    @widget.clickit
  end

  def test_navigate_to
    @driver.expects(:get).with("http://www.google.com")

    @widget.go_to_google
  end

  def test_lives_at
    @driver.expects(:get).with("/foo/bar", :relative => true)

    @widget.visit
  end

  def test_get_element
    mock_element = mock()
    mock_element.expects(:frob)
    @driver.expects(:find_element).with(:id, 'f').returns(mock_element)
    assert_nothing_raised do
      @widget.frob
    end

    assert_raises Test::Right::SelectorNotFoundError do
      @widget.frob_nonexistant
    end

    @driver.expects(:find_element).with(:id, 'foo').raises(Selenium::WebDriver::Error::NoSuchElementError)
    assert_raises Test::Right::ElementNotFoundError do
      @widget.instance_eval do
        get_element :foo
      end
    end
  end

  def test_get_elements
    @driver.expects(:find_elements).with(:css, '.foo')
    assert_nothing_raised do
      @widget.get_foos
    end
  end

  def test_lives_at
    WidgetThatDoesThings.instance_eval do
      lives_at "/foo/bar"
    end

    assert_equal "/foo/bar", WidgetThatDoesThings.instance_eval{@location}
  end

  def test_rooted_at
    WidgetThatDoesThings.instance_eval do
      rooted_at :css => '.widget'
      
      def frob
        click :thingie
      end
    end

    target = mock()
    @driver.expects(:find_element).with(:css, '.widget').returns(target)
    target.expects(:find_element).with(:id, 'f').returns(target)
    target.expects(:frob)

    @widget.frob
  end

  def test_validated_by_presence_of
    WidgetThatDoesThings.instance_eval do
      rooted_at :id => 'foo'

      validated_by_presence_of :root
    end

    @driver.expects(:find_element).with(:id, 'foo')
    assert @widget.exists?

  end

  def test_named_by
    WidgetThatDoesThings.instance_eval do
      rooted_at :css => '.widget'
      named_by :css => '.name'
    end

    target = mock()
    @driver.expects(:find_elements).with(:css, '.widget').returns([target])

    name_element = mock()
    name_element.expects(:text).returns("foo")
    target.expects(:find_element).with(:css, '.name').returns(name_element)

    assert_not_nil @widget['foo']
  end

  def test_element
    WidgetThatDoesThings.instance_eval do
      element :foo, :id => "foo"
    end
    assert_equal([:id, 'foo'], @widget.instance_eval{find_selector(:foo)})
  end

  %w<field button>.each do |thingtype|
    define_method "test_"+thingtype do
      WidgetThatDoesThings.instance_eval do
        self.send(thingtype.to_sym, :foo, :id => "foo")
      end
      assert !@widget.instance_eval{find_selector(:foo)}.empty?, "No selector was added to widget"
    end
  end

end
