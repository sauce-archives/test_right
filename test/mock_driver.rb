class MockDriver
  def initialize(config=nil)
    unless config.nil?
      @base_url = config[:base_url]
    end
  end

  def quit

  end
end

class MockElement
end
