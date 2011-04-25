class MockDriver < Test::Right::BrowserDriver
  def initialize(config=nil)
    unless config.nil?
      @base_url = config[:base_url]
    end
  end

  def quit

  end

  private
  def method_missing(name, *args)
    raise "Method Not found"
  end
end

class MockElement
end
