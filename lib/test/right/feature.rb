module Test
  module Right
    class Feature
      extend Utils::SubclassTracking
      include Assertions

      WIDGET_TIMEOUT = 10 # seconds

      def initialize(runner)
        @runner = runner
      end

      def widgets
        @runner.widgets
      end

      private
      
      def with(widget_class)
        wait_for(widget_class)
        yield widget_class.new(@runner.driver)
      end

      def wait_for(widget_class)
        widget = widget_class.new(@runner.driver)

        timeout = Time.now + WIDGET_TIMEOUT
        while Time.now < timeout
          begin
            break if widget.exists?
          rescue WidgetNotPresentError
            # ignore
          end
          sleep(0.5)
        end
        if !widget.exists?
          raise WidgetNotPresentError
        end
      end
    end
  end
end
