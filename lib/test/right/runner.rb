module Test
  module Right
    class Runner
      attr_reader :results

      def initialize(selector_library, widgets, features)
        @selectors = selector_library
        @widgets = widgets
        @features = features
        @results = {}
      end

      def run
        @features.all? do |feature|
          run_feature(feature)
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
        target = feature.new
        target.send(method)
      end
    end
  end
end
