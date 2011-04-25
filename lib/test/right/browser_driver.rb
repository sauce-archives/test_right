require 'selenium-webdriver'

module Test
  module Right
    class BrowserDriver
      def initialize(config)
        @base_url = config[:base_url]
        @driver = Selenium::WebDriver.for :firefox
      end

      def method_missing(name, *args)
        @driver.send(name, *args)
      end
    end
  end
end
