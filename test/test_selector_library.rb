require 'helper'

class TestSelectorLibrary < Test::Unit::TestCase
  def setup
    @selectors = Test::Right::SelectorLibrary.new
  end

  def test_widget_gets_added
    @selectors.widget "foo" do
    end
    assert !@selectors.widgets.empty?, "No widget was added to selector library"
  end

  %w<field button>.each do |thingtype|
    define_method "test_"+thingtype do
      @selectors.widget "foo" do
        self.send(thingtype.to_sym, :foo, :id => "foo")
      end
      assert !@selectors.widgets.empty?, "No widget was added to selector library for #{thingtype}"
    end
  end

  def test_get_selectors_for_widget
    @selectors.widget "foo" do
      field :bar, :id => 'baz'
    end

    assert_equal({:id => 'baz'}, @selectors.widgets['foo'][:bar])
  end
end
