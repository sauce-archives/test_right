module Test
  module Right
    class Runner
      attr_reader :results, :widget_classes, :driver

      def initialize(selector_library, widgets, features)
        @selectors = selector_library
        @widget_classes = widgets
        @features = features
        @results = {}
      end

      def run
        num = rand(1000)
        if $TESTING
          @driver = MockDriver.new
        else
          @driver = BrowserDriver.new
        end
        begin
          @features.all? do |feature|
            run_feature(feature)
          end
        ensure
          @driver.quit
        end
      end

      def run_feature(feature)
        feature.instance_methods.all? do |method_name|
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
        target.send(method)
      end

      def widgets
        @widget_finder ||= WidgetFinder.new(self)
      end

      def selectors_for(klass)
        name = klass.name.split(':').last.match(/^(.*)Widget$/)[1].downcase
        return @selectors.widgets[name]
      end
    end
  end
end
