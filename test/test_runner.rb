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
      field :foo, :id => 'foo'
      def an_action
      end
    end

    class TwoWordWidget < Test::Right::Widget
      def an_action
      end
    end
    CLASSDEFS
  end
  
  def teardown
    Test::Right::Widget.wipe!
    Test::Right::Feature.wipe!
  end

  def test_runs_nothing_on_nothing
    runner = Test::Right::Runner.new(Test::Right::Config.new, [], [])
    assert runner.run
  end

  def test_passes
    runner = Test::Right::Runner.new(Test::Right::Config.new, [], [PassingFeature])

    assert runner.run, "Runner should have passed: #{runner.results}"
    assert runner.results.include?(PassingFeature), "Didn't run Google Search"
  end

  def test_fails
    runner = Test::Right::Runner.new(Test::Right::Config.new, [], [FailingFeature])

    assert !runner.run, "Runner should have failed"
    assert runner.results[FailingFeature][:test_fail] != true
  end

  def test_random_test_order
    $test_sequence = []
    eval <<-FEATURES
    class FeatureA < Test::Right::Feature
      def test_aa
        $test_sequence << :aa
      end
      def test_ab
        $test_sequence << :ab
      end
      def test_ac
        $test_sequence << :ac
      end
    end

    class FeatureB < Test::Right::Feature
      def test_ba
        $test_sequence << :ba
      end
      def test_bb
        $test_sequence << :bb
      end
      def test_bc
        $test_sequence << :bc
      end
    end
    FEATURES

    runner = Test::Right::Runner.new(Test::Right::Config.new, [], [FeatureA, FeatureB])
    assert runner.run, runner.results.inspect
    first_sequence = Array.new($test_sequence)

    $test_sequence = []
    assert runner.run, runner.results.inspect
    second_sequence = Array.new($test_sequence)

    assert_not_equal first_sequence, second_sequence
  end

  def test_setup
    eval <<-CLASSDEFS
    class FeatureWithSetup < Test::Right::Feature
      def setup
        @foo = 1
      end

      def test_foo
        raise "Foo not defined" if @foo.nil?
      end
    end
    CLASSDEFS
    runner = Test::Right::Runner.new(Test::Right::Config.new, [], [FeatureWithSetup])
    assert runner.run
  end
end
