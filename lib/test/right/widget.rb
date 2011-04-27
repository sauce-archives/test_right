module Test
  module Right
    class Widget
      extend Utils::SubclassTracking

      module ClassMethods
        attr_reader :root, :name_elements, :validator, :location

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

        def named_by(*args)
          @name_elements ||= []
          if args.length == 2
            property, name_element = args
            @name_elements << [property, name_element.keys.first, name_element.values.first]
          else
            name_element = args.first
            @name_elements << [:text, name_element.keys.first, name_element.values.first]
          end
        end

        def validated_by_presence_of(selector)
          @validator = selector
        end

        def action(name, &body)
          define_method name do |*args|
            self.validate!
            self.instance_exec *args, &body
          end
        end

        def property(name, &body)
          define_method name do
            self.validate!
            Value.new do
              self.instance_eval &body
            end
          end
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
        @driver.get(self.class.location, :relative => true)
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

      def select(selector_name)
        get_element(selector_name).select
      end

      def navigate_to(url)
        @driver.get(url)
      end

      def wait_for_element_present(selector_name, timeout=10)
        endtime = Time.now + timeout
        while Time.now < endtime
          begin
            get_element(selector_name)
            return
          rescue ElementNotFoundError
          rescue WidgetNotPresentError
          end
        end
        raise ElementNotFoundError
      end

      def wait_for_element_not_present(selector_name, timeout=10)
        endtime = Time.now + timeout
        while Time.now < endtime
          begin
            get_element(selector_name)
          rescue ElementNotFoundError
            return true
          rescue WidgetNotPresentError
            return true
          end
        end
        raise Error, "Element didn't disappear"
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

        target = nil
        while target.nil?
          begin
            target = root.find_element(*selector)
          rescue Selenium::WebDriver::Error::NoSuchElementError => e
            raise ElementNotFoundError, "Element #{selector_name} not found on #{self.class.name} using #{selector.inspect}"
          rescue Selenium::WebDriver::Error::ObsoleteElementError
            # ignore
          end
        end
        return target
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
        if self.class.root.nil? && self.class.name_elements.nil?
          return @driver
        elsif self.class.root && self.class.name_elements.nil?
          begin
            return @driver.find_element(*self.class.root)
          rescue Selenium::WebDriver::Error::NoSuchElementError => e
            raise WidgetNotPresentError, "#{self.class.name} not found on page"
          end
        elsif self.class.root && self.class.name_elements
          all_instances = @driver.find_elements(*self.class.root)
          target = all_instances.find do |root_element|
            self.class.name_elements.any? do |property, how, what|
              begin
                element = root_element.find_element(how, what)
                element_name = nil
                if :value == property
                  element_name = element.attribute('value')
                else
                  element_name = element.send(property)
                end
                @name == element_name
              rescue Selenium::WebDriver::Error::ObsoleteElementError
                false
              rescue Selenium::WebDriver::Error::NoSuchElementError
                false
              end
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
