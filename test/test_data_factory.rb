require 'helper'

class TestDataFactory < Test::Unit::TestCase
  def test_uses_template
    factory = Test::Right::DataFactory.new('foo' => 'bar')
    assert factory[:foo].include? 'bar'
    assert_not_equal 'bar', factory[:foo]
  end
end
