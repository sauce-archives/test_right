module Test
  module Right
    module Assertions
      DEFAULT_ASSERTION_TIMEOUT = 15 # seconds

      def assert(timeout=DEFAULT_ASSERTION_TIMEOUT)
        if !block_given?
          raise ArgumentError, "assert requires a block"
        end

        start = Time.now
        while Time.now-start < timeout
          begin
            if yield
              return
            end
          rescue WidgetNotPresentError
          end
          sleep(0.5)
        end

        raise AssertionFailedError, "Assertion failed after #{timeout} seconds"
      end

      def assert_equal(expected, actual, timeout=DEFAULT_ASSERTION_TIMEOUT)
        if actual.is_a? Value
          assert do
            expected == actual.value
          end
        else
          raise AssertionFailedError, "Expected #{expected.inspect} but got #{actual.inspect}" unless expected == actual
        end
      end
    end
  end
end
