module Test
  module Right
    class WidgetFinder
      def initialize(runner)
        @runner = runner
        @widget_classes = runner.widget_classes
        @widgets = {}
      end

      def [](name)
        if name.is_a? Symbol
          name = name.to_s
        end
        name.downcase!
        klass = @widget_classes.find do |widget|
          widget_name = widget.name.split(":").last
          if widget_name =~ /^(.*)Widget/
            widget_name = $1
          end
          widget_name.downcase!
          name == widget_name
        end

        if klass.nil?
          raise WidgetNotFoundError, "Widget for \"#{name}\" not found"
        end

        @widgets[klass] ||= klass.new(@runner.driver, @runner.selectors_for(klass))
      end
    end
  end
end
