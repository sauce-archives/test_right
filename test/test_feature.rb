require 'helper'

class TestFeature < Test::Unit::TestCase
  def setup
    eval <<-CLASSDEFS
    class FooWidget < Test::Right::Widget
      def bar
      end
    end

    class FeatureThatUsesOneWidget < Test::Right::Feature
      def test_widget
        widgets[:foo].bar
      end
    end
    CLASSDEFS
  end
  def teardown
    Test::Right::Feature.wipe!
    Test::Right::Widget.wipe!
  end

  def test_has_access_to_widgets
    runner = Test::Right::Runner.new(Test::Right::SelectorLibrary.new, [FooWidget], [])
    feature = FeatureThatUsesOneWidget.new(runner)
    feature.test_widget
  end
end
