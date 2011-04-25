require 'helper'

class TestBrowserDriver < Test::Unit::TestCase
  def test_extracts_base_url
    Selenium::WebDriver.expects(:for).with(:firefox)
    config = Test::Right::Config.new({'base_url' => "http://saucelabs.com/"})
    driver = Test::Right::BrowserDriver.new(config)
    base_url = driver.instance_eval {@base_url}
    assert_equal "http://saucelabs.com", base_url
  end

  def test_delegates
    selenium = Object.new
    selenium.expects(:foo)
    Selenium::WebDriver.expects(:for).with(:firefox).returns(selenium)
    config = Test::Right::Config.new({'base_url' => "http://saucelabs.com/"})
    driver = Test::Right::BrowserDriver.new(config)
    driver.foo
  end

  def test_get_relative
    selenium = Object.new
    selenium.expects(:get).with("http://saucelabs.com/foo")
    Selenium::WebDriver.expects(:for).with(:firefox).returns(selenium)
    config = Test::Right::Config.new({'base_url' => "http://saucelabs.com/"})
    driver = Test::Right::BrowserDriver.new(config)
    driver.get("/foo", :relative => true)
  end

  def test_get_absolute
    selenium = Object.new
    selenium.expects(:get).with("foo")
    Selenium::WebDriver.expects(:for).with(:firefox).returns(selenium)
    config = Test::Right::Config.new({'base_url' => "http://saucelabs.com/"})
    driver = Test::Right::BrowserDriver.new(config)
    driver.get("foo")
  end
end
