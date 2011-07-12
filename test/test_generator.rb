require 'helper'
require 'fileutils'

class TestGenerator < Test::Unit::TestCase
  include TestRightTestingUtils

  def setup
    @generator = Test::Right::Generator.new([])
  end

  def test_generate
    in_new_dir do
      @generator.generate
      assert File.exists? "test/right/config.yml"
      assert File.exists? "test/right/setup.rb"
      assert File.executable? "test/right/setup.rb"
    end
  end
end
