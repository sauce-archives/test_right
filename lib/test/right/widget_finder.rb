module Test
  module Right
    class WidgetFinder
      def initialize(runner)
        @runner = runner
        @widget_classes = runner.widget_classes
        @widgets = {}
      end


      def [](name)
        original_name = name
        if name.is_a? Symbol
          name = name.to_s
        end
        name.gsub!(/ /, '_')
        name = camelize(name)

        name += "Widget"

        klass = @widget_classes.find do |widget|
          widget_name = widget.name.split(":").last
          name == widget_name
        end

        if klass.nil?
          raise WidgetNotFoundError, "Widget for \"#{original_name}\" not found"
        end

        selectors = @runner.selectors_for(klass)

        if selectors.nil?
          raise SelectorsNotFoundError, "Selectors for \"#{original_name}\" widget not found"
        end
        @widgets[klass] ||= klass.new(@runner.driver, selectors)
      end
      
      private

      def camelize(word)
        word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      end
    end
  end
end
