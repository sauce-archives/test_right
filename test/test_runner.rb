require 'test_helper'

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
    CLASSDEFS
  end

  def test_runs_nothing_on_nothing
    runner = Test::Right::Runner.new(nil, [], [])
    assert runner.run
  end

  def test_passes
    library = Test::Right::SelectorLibrary.new
    runner = Test::Right::Runner.new(library, [], [PassingFeature])

    assert runner.run, "Runner should have passed"
    assert runner.results.include?(PassingFeature), "Didn't run Google Search"
  end

  def test_fails
    library = Test::Right::SelectorLibrary.new
    runner = Test::Right::Runner.new(library, [], [FailingFeature])

    assert !runner.run, "Runner should have failed"
    assert runner.results[FailingFeature][:test_fail] != true
  end
  
  def teardown
    Test::Right::Widget.wipe!
    Test::Right::Feature.wipe!
  end
end
