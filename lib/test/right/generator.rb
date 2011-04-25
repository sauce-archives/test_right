require 'fileutils'

module Test
  module Right
    class Generator
      include FileUtils

      def initialize(args)
        @args = args
      end

      def generate
        mkdir_p("test/right/features")
        mkdir_p("test/right/widgets")

        touch("test/right/selectors.rb")
      end
    end
  end
end
