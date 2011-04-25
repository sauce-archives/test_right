module Test
  module Right
    class Widget
      extend Utils::SubclassTracking

      def initialize(driver, selectors)
        @driver = driver
        @selectors = selectors
      end

      def fill_in(selector_name, value)
      end

      def method_missing(name, *args)
        raise WidgetActionNotImplemented, "#{self.class.to_s}##{name.to_s} not implemented"
      end

      private

      def get_element(selector_name)
      end
    end
  end
end
