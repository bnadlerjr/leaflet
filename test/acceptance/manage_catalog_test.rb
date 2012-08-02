require_relative "acceptance_helper"

module Leaflet
  class ManageCatalogTest < AcceptanceTest
    # Given I am an admin
    # When I go to the Manage Catalog page
    #   And I fill in the new book form correctly
    #   And I submit the form
    # Then I should see a message that I added the book
    #   And I should see the book in the catalog
    test "admin adds a book" do
      page.driver.browser.basic_authorize('admin', 'secret')
      visit '/'
      click_on 'Manage Catalog'
      fill_in 'Title', :with => 'My New Book'
      fill_in 'Description', :with => 'A description of a new book.'
      fill_in 'Price', :with => '23.99'
      click_on 'Add Book'

      assert(page.has_content?('Successfully added book.'),
        "expected to see a message that book was added")

      assert(page.has_content?('My New Book'),
        "expected to see 'My New Book' in the catalog")
    end

    # Given I am not an admin
    # When I go to the Manage Catalog page
    # Then I should see a message telling me I'm not authorized
    test "non-admin attempts to add book" do
      visit '/'
      click_on 'Manage Catalog'

      assert(page.has_content?('Not authorized'),
        'expected to see a not authorized message')
    end
  end
end
