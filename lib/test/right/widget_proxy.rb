module Test
  module Right
    class WidgetProxy
      def initialize(klass, name)
        @klass = klass
        @name = name
      end

      def new(driver)
        @klass.new(driver, @name)
      end
    end
  end
end
