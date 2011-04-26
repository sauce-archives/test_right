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
          if yield
            return
          end
          sleep(0.5)
        end

        raise AssertionFailedError, "Assertion failed after #{timeout} seconds"
      end
    end
  end
end
