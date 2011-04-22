module Test
  module Right
    class SelectorLibrary
      class Widget
        def field(name, locator)
        end
        
        def button(name, locator)

        end
      end

      def initialize
        @widgets = []
      end

      def widget(name, &definition)
        w = Widget.new
        w.instance_eval(&definition)
        @widgets << w
      end

      def widgets
        @widgets
      end
    end
  end
end
