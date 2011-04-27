module Test
  module Right
    class Widget
      extend Utils::SubclassTracking

      module ClassMethods
        def selector(name)
          @selectors[name]
        end

        def element(name, locator)
          @selectors[name] = locator
        end

        def lives_at(url)
          @location = url
        end

        alias_method :button, :element
        alias_method :field, :element
      end

      def self.inherited(subclass)
        @subclasses ||= [] 
        @subclasses << subclass 
        subclass.instance_eval do
          @selectors = {}
          @location = nil
        end

        subclass.extend(ClassMethods)
      end

      def initialize(driver)
        @driver = driver
      end

      def visit
        @driver.get(@location, :relative => true)
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
        if !self.class.selector(selector_name)
          raise SelectorNotFoundError, "Selector \"#{selector_name}\" for Widget \"#{self.class}\" not found"
        end

        selector = self.class.selector(selector_name)
        return [selector.keys.first, selector.values.first]
      end
    end
  end
end
