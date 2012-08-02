require_relative "acceptance_helper"

module Leaflet
  class BrowseCatalogTest < AcceptanceTest
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

    # Given I am an admin
    #  And an 'inactive' book is in the catalog
    # When I go to the home page
    # Then I should see the inactive book
    test "admin browsing catalog should see 'inactive' books" do
      page.driver.browser.basic_authorize('admin', 'secret')
      visit '/'

      assert(page.has_content?("Eloquent Ruby"),
        "expected to see 'Eloquent Ruby' on the page")
    end
  end
end