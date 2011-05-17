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

        open("test/right/config.yml", 'wb') do |file|
          file.write <<-EOF
# The base URL of your staging server
base_url: http://example.com/

# Which browser you want to run your tests in
browser: firefox
          EOF
        end

        open("test/right/setup.rb", 'wb') do |file|
          file.write "\n"
        end
        File.chmod(0755, "test/right/setup.rb")
      end
    end
  end
end
