module Test
  module Right
    class Value
      def initialize(&body)
        @body = body
      end

      def value
        @body.call
      end
    end
  end
end
