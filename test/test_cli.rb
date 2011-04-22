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
end
