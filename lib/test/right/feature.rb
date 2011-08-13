module Test
  module Right
    class Feature
      extend Utils::SubclassTracking
      include Assertions

      attr_reader :data

      WIDGET_TIMEOUT = 10 # seconds

      def self.test(name, &b)
        define_method "test_#{name.gsub(' ', '_')}", &b
      end

      def initialize(driver, data)
        @driver = driver
        @data = data
      end

      private

      
      def with(widget_class)
        wait_for(widget_class)
        yield widget_class.new(@driver)
      end

      def wait_for(widget_class)
        widget = widget_class.new(@driver)

        timeout = Time.now + WIDGET_TIMEOUT
        while Time.now < timeout
          break if widget.exists?
          sleep(0.25)
        end
        if !widget.exists?
          raise WidgetNotPresentError
        end
      end
    end
  end
end
