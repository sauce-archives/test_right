module Test
  module Right
    class Error < StandardError; end
    class ConfigurationError < Error; end
    class WidgetActionNotImplemented < Error; end
    class WidgetNotFoundError < Error; end
    class SelectorNotFoundError < Error; end
    class SelectorsNotFoundError < Error; end
    class ElementNotFoundError < Error; end
    class AssertionFailedError < Error; end
    class WidgetConfigurationError < Error; end
    class WidgetNotPresentError < Error; end
    class IAmConfusedError < Error; end
  end
end
