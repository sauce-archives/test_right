module Test
  module Right
    class Feature
      extend Utils::SubclassTracking
      include Assertions

      def initialize(runner)
        @runner = runner
      end

      def widgets
        @runner.widgets
      end
    end
  end
end
