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
    end
  end
end
