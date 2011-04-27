require 'helper'

class TestWidgetFinder < Test::Unit::TestCase
  def setup
    eval <<-CLASSDEFS
    class SimpleWidget < Test::Right::Widget
    end

    class NoSelectorsWidget < Test::Right::Widget
    end

    class TwoWordWidget < Test::Right::Widget
    end
    CLASSDEFS

    runner = Test::Right::Runner.new(Test::Right::Config.new, [SimpleWidget, TwoWordWidget, NoSelectorsWidget], [])
    @widget_finder = Test::Right::WidgetFinder.new(runner)
  end

  def teardown
    Test::Right::Widget.wipe!
    Test::Right::Feature.wipe!
  end

  def test_simple_match
    @widget_finder["simple"].is_a? SimpleWidget
    @widget_finder[:simple].is_a? SimpleWidget
    @widget_finder["Simple"].is_a? SimpleWidget

    @widget_finder["two word"].is_a? TwoWordWidget
    @widget_finder[:two_word].is_a? TwoWordWidget

    assert_raises Test::Right::WidgetNotFoundError do
      @widget_finder["not here"]
    end
  end
end
