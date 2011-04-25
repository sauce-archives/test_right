module Test
  module Right
    class Config
      def initialize(options={})
        @options = options
      end

      def [](name)
        @options[name] || @options[name.to_s]
      end
    end
  end
end
