module Test
  module Right
    class Feature
      extend Utils::SubclassTracking

      def initialize(runner)
        @runner = runner
      end

      def widgets
        @runner.widgets
      end
    end
  end
end
