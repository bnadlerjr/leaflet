ENV['RACK_ENV'] = 'test'

require "test/unit"
require "contest"

require 'minitest/reporters'
MiniTest::Reporters.use!

require "capybara"
require "capybara/dsl"

require_relative "../../lib/leaflet"

module Leaflet
  class BrowseCatalogTest < Test::Unit::TestCase
    include Capybara::DSL

    setup do
      Capybara.app = Leaflet::Server

      Capybara.app.set :catalog, [
          { 'title'       => 'The Well-Grounded Rubyist',
            'description' => 'This is an awesome book!',
            'price'       => 44.99,
            'status'      => 'active'
          },
          { 'title'       => 'Eloquent Ruby',
            'description' => 'Another awesome book about Ruby!',
            'price'       => 30.67,
            'status'      => 'inactive'
          }
      ]
    end

    teardown do
      Capybara.reset_sessions!
      Capybara.use_default_driver
    end

    # Given I am not an admin
    #   And "The Well-Grounded Rubyist" is in the catalog
    # When I go to the home page
    # Then I should see the book's title, description, price
    test "customer browses catalog" do
      visit '/'

      assert(page.has_content?("The Well-Grounded Rubyist"),
        "expected to see 'The Well-Grounded Rubyist'")

      assert(page.has_content?("This is an awesome book!"),
        "expected to see 'This is an awesome book!'")

      assert(page.has_content?("Price: $44.99"),
        "expected to see 'Price: $44.99'")
    end

    # Given I am not an admin
    #   And an 'inactive' book is in the catalog
    # When I go to the home page
    # Then I should not see the inactive book
    test "customer browsing catalog should not see 'inactive' books" do
      visit '/'

      assert(!page.has_content?("Eloquent Ruby"),
        "did not expect to see 'Eloquent Ruby' on the page")
    end
  end
end