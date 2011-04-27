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

        def [](name)
          WidgetProxy.new(self, name)
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

      attr_reader :name

      def initialize(driver, name=nil)
        @driver = driver
        @name = name
      end

      def visit
        @driver.get(@location, :relative => true)
      end

      def exists?
        begin
          root
          return true
        rescue WidgetNotPresentError
          return false
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

      def clear(selector_name)
        get_element(selector_name).clear
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

        begin
          root.find_element(*selector)
        rescue Selenium::WebDriver::Error::NoSuchElementError => e
          raise ElementNotFoundError, "Element #{selector_name} not found on #{self.class.name} using #{selector.inspect}"
        end
      end

      def get_elements(selector_name)
        selector = find_selector(selector_name)
        begin
          element = root.find_elements(*selector)
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

      def root
        if self.class.root.nil? && self.class.name_element.nil?
          return @driver
        elsif self.class.root && self.class.name_element.nil?
          begin
            return @driver.find_element(*self.class.root)
          rescue Selenium::WebDriver::Error::NoSuchElementError => e
            raise WidgetNotPresentError, "#{self.class.name} not found on page"
          end
        elsif self.class.root && self.class.name_element
          all_instances = @driver.find_elements(*self.class.root)
          target = all_instances.find do |root_element|
            begin
              element_name = root_element.find_element(*self.class.name_element).text
              @name == element_name
            rescue Selenium::WebDriver::Error::ObsoleteElementError
              false
            end
          end
          if target.nil?
            raise WidgetNotPresentError, "#{self.class.name} with name \"#{name}\" not found"
          end
          
          return target
        else
          raise IAmConfusedError
        end
      end
    end
  end
end
