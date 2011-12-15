require 'yaml'
require 'optparse'

module Test
  module Right
    class CLI
      RUBY_FILE = /^[^.].+.rb$/


      def start(argument_list)
        if argument_list.first == "install"
          Generator.new(argument_list[1..-1]).generate
          return
        else
          load_and_run_tests
        end
      end

      def load_and_run_tests
        run_setup

        subdir = false
        if File.directory? "test/right"
          Dir.chdir("test/right")
          subdir = true
        end

        load_config
        load_widgets
        load_features

        OptionParser.new do |opts|
          opts.on("-s", "--slow", "Run slower so you can see what's happening") do |v|
            @config[:slow] = true
          end
          opts.on("-h", "--help", "Show this message") do
            puts opts
            exit
          end
        end.parse!
        
        Dir.chdir("../..") if subdir

        puts "Running #{features.size} features"
        runner = Runner.new(config, widgets, features)
        if runner.run
          puts "Passed!"
        else
          at_exit {
            exit(1)
          }
          puts "Failed:"
          runner.results.each do |feature, feature_result|
            puts "  #{feature}"
            feature_result.each do |method, result|
              if result.is_a? Exception
                if result.is_a? WidgetActionNotImplemented
                  puts "    #{method} => #{result}"
                else
                  puts "    #{method} => #{result.class} - #{result}"
                  result.backtrace.each do |trace|
                    puts "      #{trace}"
                  end
                end
              else
                puts "    #{method} => #{result}"
              end
            end
          end
        end
      end

      def run_setup
        if File.exists? "setup.rb"
          unless system("./setup.rb")
            raise ConfigurationError, "Setup failed"
          end
        elsif File.exists? "test/right/setup.rb"
          unless system("test/right/setup.rb")
            raise ConfigurationError, "Setup failed"
          end
        end
      end

      def load_config
        options = {}
        if File.exists? "config.yml"
          options = YAML.load(open("config.yml"))
        end
        @config = Config.new(options)
      end

      def config
        @config
      end

      def load_widgets
        raise ConfigurationError, "no widgets/ directory" unless File.directory? "widgets"
        load_ruby_in_dir("widgets")
      end

      def widgets
        Widget.subclasses || []
      end

      def load_features
        raise ConfigurationError, "no features/ directory" unless File.directory? "features"
        load_ruby_in_dir("features")
      end

      def features
        Feature.subclasses || []
      end

      private
      
      def load_ruby_in_dir(dirname)
        Dir.foreach dirname do |filename|
          unless [".", ".."].include? filename
            if filename =~ RUBY_FILE
              load "#{dirname}/#{filename}"
            end
          end
        end
      end
    end
  end
end
