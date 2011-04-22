module Test
  module Right
    class CLI
      def self.start(argument_list)
        cli = self.new
        cli.load_selectors
      end

      def initialize
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

      def load_widgets
        raise ConfigurationError, "no widgets/ directory" unless File.directory? "widgets"

        Dir.foreach "widgets" do |widget_definition|
          unless [".", ".."].include? widget_definition
            load "widgets/#{widget_definition}"
          end
        end
      end

      def widgets
        Widget.subclasses
      end
    end
  end
end
