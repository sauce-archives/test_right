Test::Right - Opinionated full-stack browser testing
=================================================

Test::Right is a testing framework designed to help users get maximum value out
of browser testing. It provides a flexible Page Object model for building
robust, reliable tests quickly and easily. No more slogging through XPaths in
Selenium IDE: Test::Right is the right way to build browser tests.

Setup
-----

    gem install test_right
    cd MY_APP
    test_right install

The test_right executable will create a default directory structure in
test/right for you to put your tests in.

Begin by setting the base_url setting in test/right/config.yml to the base URL
of your application staging environment. Then add the necessary code to reset
your application state and launch your server to setup.rb.

Tests are defined in terms of _actions_ and _properties_ on _widgets_. A
widget is a piece of functionality present on one more more pages of your
application. A single page can have many widgets, and multiple copies of a
widget may appear on the same page.

To get started, add widget definitions to the widgets/ directory. A widget
defines its elements in terms of standard Selenium 2 selectors and actions in
terms of those elements. For example, something like this in
test/right/widgets/login.rb:

    class LoginWidget < Test::Right::Widget
      field :username, :id => 'username'
      button :login, :css => "input[type=submit]"

      action :login do |username, password|
        fill_in :username, username
        click :login
      end
    end

    class CartWidget  < Test::Right::Widget
      element :count, :id => 'item_count'

      property :number_of_items do
        get_element(:count).text
      end
    end

Once your widgets are setup, write tests for features of your application in
test/right/features. For example, something like this would go in
test/right/features/shopping_cart.rb:

    class ShoppingCartFeature < Test::Right::Feature
      def setup
        with LoginWidget do |w|
          w.login
        end
      end

      def test_adding_item
        with ItemWidget do |w|
          w.add_an_item
        end

        with CartWidget do |w|
          assert_equal, 1, w.number_of_items 
        end
      end
    end

Learn more on the Test::Right wiki at https://github.com/saucelabs/test_right/wiki
