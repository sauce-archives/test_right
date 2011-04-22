require 'test_helper'
require 'tmpdir'

class TestCLI < Test::Unit::TestCase
  def test_raises_when_cant_find_selectors
    assert_raises Test::Right::ConfigurationError do
      cli = Test::Right::CLI.new
      cli.load_selectors
    end
  end

  def test_parses_selectors
    Dir.mktmpdir do |path|
      Dir.chdir(path)
      File.open "selectors.rb", "wb" do |f|
        f.print <<-SELECTORS
        widget "Foo" do
          field :foo, :id => 'bar'
        end
        SELECTORS
      end

      cli = Test::Right::CLI.new
      cli.load_selectors

      selectors = cli.instance_eval do
        @selectors
      end
      
      assert !selectors.widgets.empty?, "No widget found from generated selectors.rb"
    end
  end

  def test_fails_with_no_widgets_dir
    assert_raises Test::Right::ConfigurationError do
      cli = Test::Right::CLI.new
      cli.load_widgets
    end
  end

  def test_finds_widgets
    Dir.mktmpdir do |path|
      Dir.chdir(path)
      File.open "selectors.rb", "wb" do |f|
        f.print <<-SELECTORS
        widget "Foo" do
          field :foo, :id => 'bar'
        end
        SELECTORS
      end

      Dir.mkdir("widgets")

      File.open "widgets/foo_widget.rb", 'wb' do |f|
        f.print <<-WIDGET
        class FooWidget < Test::Right::Widget
        end
        WIDGET
      end

      cli = Test::Right::CLI.new
      cli.load_selectors
      cli.load_widgets
      
      assert !cli.widgets.empty?, "No widgets loaded"
    end
  end
end
