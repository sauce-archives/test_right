module Test
  module Right
    class SelectorLibrary
      class Widget
        def initialize
          @selectors = {}
        end

        def [](name)
          @selectors[name]
        end

        def include?(name)
          @selectors.include? name
        end
        
        private

        def field(name, locator)
          @selectors[name] = locator
        end
        
        def button(name, locator)
          @selectors[name] = locator
        end
      end

      def initialize
        @widgets = {}
      end

      def widget(name, &definition)
        w = Widget.new
        w.instance_eval(&definition)
        @widgets[name.downcase] = w
      end

      def widgets
        @widgets
      end
    end
  end
end
