module Test
  module Right
    class ConfigurationError < StandardError; end
    class WidgetActionNotImplemented < StandardError; end
    class WidgetNotFoundError < StandardError; end
    class SelectorNotFoundError < StandardError; end
    class SelectorsNotFoundError < StandardError; end
  end
end
