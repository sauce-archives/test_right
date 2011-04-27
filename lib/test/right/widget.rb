module Test
  module Right
    class Widget
      extend Utils::SubclassTracking

      module ClassMethods
        attr_reader :root, :name_element, :validator

        def selector(name)
          @selectors[name]
        end

        def element(name, locator)
          @selectors[name] = locator
        end

        def lives_at(url)
          @location = url
        end

        def rooted_at(root)
          @root = [root.keys.first, root.values.first]
          @selectors[:root] = root
        end

        def named_by(name_element)
          @name_element = [name_element.keys.first, name_element.values.first]
        end

        def validated_by_presence_of(selector)
          @validator = selector
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

      def initialize(driver, root=nil)
        @driver = driver
        @root = root
      end

      def visit
        @driver.get(@location, :relative => true)
      end

      def [](name)
        raise WidgetConfigurationError, "Tried to look up a #{self.class.name}, but it doesn't have a root" if self.class.root.nil?
        raise WidgetConfigurationError, "Tried to look up a #{self.class.name}, but it doesn't have a naming element" if self.class.name_element.nil?

        all_instances = @driver.find_elements(*self.class.root)
        target = all_instances.find do |root_element|
          name == root_element.find_element(*self.class.name_element).text
        end
        return self.class.new(@driver, target)
      end

      def exists?
        if self.class.validator
          begin
            get_element(self.class.validator)
            return true
          rescue ElementNotFoundError
            return false
          end
        else
          # Raise exception?
          return true
        end
      end

      def validate!(timeout=15)
        timeout = Time.now + timeout
        while Time.now < timeout
          if self.exists?
            return
          end
        end
        raise WidgetNotPresentError
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
        if selector_name == :root
          begin
            return @driver.find_element(*self.class.root)
          rescue Selenium::WebDriver::Error::NoSuchElementError => e
            raise ElementNotFoundError, e.message
          end
        end

        root = @driver
        if self.class.root
          begin
            root = @driver.find_element(*self.class.root)
          rescue Selenium::WebDriver::Error::NoSuchElementError => e
            raise ElementNotFoundError, "root of #{self.class.name} not found using #{self.class.root.inspect}"
          end
        end

        begin
          root.find_element(*selector)
        rescue Selenium::WebDriver::Error::NoSuchElementError => e
          raise ElementNotFoundError, "Element #{selector_name} not found on #{self.class.name} using #{selector.inspect}"
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
