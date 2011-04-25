test_right: Opinionated full-stack browser testing
=================================================

test_right is a testing framework designed to help users get maximum value out
of browser testing.

Setup
-----

    gem install test_right
    cd MY_APP
    test_right install

The test_right executable will create a default directory structure in
test/right for you to put your tests in.

Begin by locating the testable elements on your pages and adding their
locators to selectors.rb:

    widget "login" do
      field :username, :id => 'username'
      button :login, :xpath => "//input[@type='submit']"
    end

Once you've identified enough elements to write your tests, implement the
actions of your widgets in widgets/. For example, something like the following
in test/right/widgets/login.rb.

    class LoginWidget < Test::Right::Widget
      def login(username, password)
        fill_in :username, username
        click :login
      end
    end

Each widget class should be associated with a particular piece of
functionality on one or more web pages. It's up to you to organize your
widgets as you see fit.

Once your widgets are setup, you can test features by adding files in
test/right/features/. For example, test/right/features/shopping_cart.rb:

    class ShoppingCartFeature < Test::Right::Feature
      def test_adding_item
        widgets[:login].login
        widgets[:item].add_an_item
        widgets[:cart].validate!
      end
    end
