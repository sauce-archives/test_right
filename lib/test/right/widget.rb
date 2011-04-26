module Test
  module Right
    class Widget
      extend Utils::SubclassTracking

      def initialize(driver, selectors)
        @driver = driver
        @selectors = selectors
      end

      def visit
        @driver.get(@selectors.location, :relative => true)
      end

      def method_missing(name, *args)
        raise WidgetActionNotImplemented, "#{self.class.to_s}##{name.to_s} not implemented"
      end

      private

      def fill_in(selector_name, value)
        get_element(selector_name).send_keys(value)
      end
      
      def click(selector_name)
        get_element(selector_name).click
      end

      def navigate_to(url)
        @driver.get(url)
      end

      def get_element(selector_name)
        selector = find_selector(selector_name)
        begin
          element = @driver.find_element(*selector)
        rescue Selenium::WebDriver::Error::NoSuchElementError => e
          raise ElementNotFoundError, e.message
        end
      end

      def get_elements(selector_name)
        selector = find_selector(selector_name)
        begin
          element = @driver.find_elements(*selector)
        rescue Selenium::WebDriver::Error::NoSuchElementError => e
          raise ElementNotFoundError, e.message
        end
      end

      def find_selector(selector_name)
        if !@selectors.include?(selector_name)
          raise SelectorNotFoundError, "Selector \"#{selector_name}\" for Widget \"#{self.class}\" not found"
        end

        selector = @selectors[selector_name]
        return [selector.keys.first, selector.values.first]
      end
    end
  end
end
