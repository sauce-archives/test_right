module Test
  module Right
    class Runner
      attr_reader :results, :widget_classes, :driver

      def initialize(config, widgets, features)
        @config = config
        @widget_classes = widgets
        @features = features
        @results = {}
      end

      def run
        if $MOCK_DRIVER
          @driver = MockDriver.new(@config)
        else
          @driver = BrowserDriver.new(@config)
        end

        begin
          @features.sort_by{|x| rand(10000)}.all? do |feature|
            run_feature(feature)
          end
        ensure
          @driver.quit
        end
      end

      def run_feature(feature)
        methods = feature.instance_methods
        methods.sort_by{|x| rand(10000)}.all? do |method_name|
          @results[feature] = {}
          begin
            if method_name =~ /^test_/
              method = method_name.to_sym
              @results[feature][method] = true
              run_test(feature, method_name.to_sym)
            end
            true
          rescue => e
            @results[feature][method] = e
            false
          end
        end
      end

      def run_test(feature, method)
        target = feature.new(self)
        if target.respond_to? :setup
          target.setup
        end
        target.send(method)
      end

      def widgets
        @widget_finder ||= WidgetFinder.new(self)
      end
    end
  end
end
