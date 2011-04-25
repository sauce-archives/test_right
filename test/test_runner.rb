require 'helper'

class TestRunner < Test::Unit::TestCase
  def setup
    eval <<-CLASSDEFS
    class PassingFeature < Test::Right::Feature
      def test_pass
      end
    end

    class FailingFeature < Test::Right::Feature
      def test_fail
        raise "FAIL"
      end
    end

    class SimpleWidget < Test::Right::Widget
      def an_action
      end
    end
    CLASSDEFS
  end

  def test_runs_nothing_on_nothing
    runner = Test::Right::Runner.new(nil, [], [])
    assert runner.run
  end

  def test_passes
    library = Test::Right::SelectorLibrary.new
    runner = Test::Right::Runner.new(library, [], [PassingFeature])

    assert runner.run, "Runner should have passed: #{runner.results}"
    assert runner.results.include?(PassingFeature), "Didn't run Google Search"
  end

  def test_fails
    library = Test::Right::SelectorLibrary.new
    runner = Test::Right::Runner.new(library, [], [FailingFeature])

    assert !runner.run, "Runner should have failed"
    assert runner.results[FailingFeature][:test_fail] != true
  end

  def test_widgets
    library = Test::Right::SelectorLibrary.new
    runner = Test::Right::Runner.new(library, [SimpleWidget], [FailingFeature])
    assert runner.widgets["simple"].is_a? SimpleWidget
  end

  def test_injects_selectors_into_widgets
    library = Test::Right::SelectorLibrary.new
    library.widget "simple" do
      field :foo, :id => 'foo'
    end
    runner = Test::Right::Runner.new(library, [SimpleWidget], [])
    widget = runner.widgets["simple"]
    selectors = widget.instance_eval{@selectors}
    assert_not_nil selectors
    assert_equal({:id => 'foo'}, selectors[:foo])
  end
  
  def teardown
    Test::Right::Widget.wipe!
    Test::Right::Feature.wipe!
  end
end