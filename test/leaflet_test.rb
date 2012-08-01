require_relative "test_helper"
require "rack/test"
require_relative 'support/rack_test_assertions'

require_relative "../lib/leaflet"

module Leaflet
  class ServerTest < Test::Unit::TestCase
    include Rack::Test::Methods
    include Rack::Test::Assertions

    setup do
      app.set :catalog, []
    end

    test "GET '/'" do
      get '/'

      assert_response :ok
      assert_body_contains "Leaflet"
    end

    test "GET /books/new" do
      get '/books/new'

      assert_response :ok
      assert_body_contains "Add Book"
    end

    test "successful POST /books" do
      post '/books', 'book' => book_params

      assert_response :redirect
      assert_flash_message 'Successfully added book.'
      assert_includes(app.catalog, book_params.merge('status' => 'active'))

      follow_redirect!
      assert_body_contains(book_params['title'])
    end

    test "unsuccessful POST /books" do
      invalid_book_params = book_params('title' => '')

      post '/books', 'book' => invalid_book_params

      assert_response :ok
      assert_flash_message 'There were errors that prevented the book from being added.'
      assert_not_include(app.catalog, invalid_book_params)
      assert_body_contains('title cannot be blank')
    end

    private

    def app
      Leaflet::Server
    end

    def book_params(attributes={})
      {
        'title' => 'Some Book',
        'description' => 'A description of the book.',
        'price'       => '9.99'
      }.merge(attributes)
    end
  end
end