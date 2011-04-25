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
        if $MOCK_DRIVER
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
        name = klass.name.split(':').last.match(/^(.*)Widget$/)[1]
        name = underscore(name).gsub(/_/, ' ')
        return @selectors.widgets[name]
      end

      private

      def underscore(camel_cased_word)
        word = camel_cased_word.to_s.dup
        word.gsub!(/::/, '/')
        word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        word.tr!("-", "_")
        word.downcase!
        word
      end

    end
  end
end
