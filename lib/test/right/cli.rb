module Test
  module Right
    class CLI
      RUBY_FILE = /^[^.].+.rb$/


      def start(argument_list)
        load_selectors
        load_widgets
        load_features

        Runner.new(selectors, widgets, features).run
      end


      def load_selectors
        begin
          selectors_definition = IO.read('selectors.rb')
          @selectors = SelectorLibrary.new
          @selectors.instance_eval(selectors_definition)
        rescue Errno::ENOENT
          raise ConfigurationError, "selectors.rb not found"
        end
      end

      def selectors
        @selectors
      end

      def load_widgets
        raise ConfigurationError, "no widgets/ directory" unless File.directory? "widgets"

        Dir.foreach "widgets" do |widget_definition|
          unless [".", ".."].include? widget_definition
            if widget_definition =~ RUBY_FILE
              load "widgets/#{widget_definition}"
            end
          end
        end
      end

      def widgets
        Widget.subclasses || []
      end

      def load_features
        raise ConfigurationError, "no features/ directory" unless File.directory? "features"

        Dir.foreach "features" do |feature_definition|
          unless [".", ".."].include? feature_definition
            if feature_definition =~ RUBY_FILE
              load "features/#{feature_definition}"
            end
          end
        end
      end

      def features
        Feature.subclasses || []
      end
    end
  end
end
