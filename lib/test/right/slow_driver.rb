module Test
  module Right
    class SlowDriver
      def initialize(driver)
        @driver = driver
      end

      def method_missing(*args)
        result = nil
        begin
          result = @driver.send(*args)
        ensure
          sleep 2
        end
        return result
      end
    end
  end
end
