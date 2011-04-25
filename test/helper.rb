require 'rubygems'
require 'test/right'
require 'test/unit'
require 'mock_driver'
require 'mocha'

$MOCK_DRIVER = true

module TestRightTestingUtils
  def in_new_dir
    Dir.mktmpdir do |path|
      Dir.chdir(path) do
        yield
      end
    end
  end
end
