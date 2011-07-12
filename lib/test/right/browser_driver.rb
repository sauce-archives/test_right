require 'selenium-webdriver'

module Test
  module Right
    class BrowserDriver
      def initialize(config)
        @base_url = config[:base_url]
        if @base_url =~ /\/$/
          @base_url = @base_url[0..-2]
        end
        @driver = Selenium::WebDriver.for config[:browser].to_sym
      end

      def get(url, options = {})
        if options[:relative]
          @driver.get(relative_url(url))
        else
          @driver.get(url)
        end
      end

      private

      def relative_url(url)
        raise ConfigurationError, "No base_url in config.yml" if @base_url.nil?
        @base_url + url
      end

      def method_missing(name, *args)
        @driver.send(name, *args)
      end
    end
  end
end
