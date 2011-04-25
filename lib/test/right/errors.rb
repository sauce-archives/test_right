module Test
  module Right
    class Error < StandardError; end
    class ConfigurationError < Error; end
    class WidgetActionNotImplemented < Error; end
    class WidgetNotFoundError < Error; end
    class SelectorNotFoundError < Error; end
    class SelectorsNotFoundError < Error; end
    class ElementNotFoundError < Error; end
  end
end
