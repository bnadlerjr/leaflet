require_relative '../test_helper'
require_relative '../../lib/leaflet/add_book_to_catalog'

module Leaflet
  class AddBookToCatalogTest < Test::Unit::TestCase
    context "book params are valid" do
      setup do
        @catalog = Fakes.catalog

        @my_errors = nil
        command = AddBookToCatalog.new(@catalog, Fakes.book_params) do |errors|
          @my_errors = errors
        end

        command.call
      end

      test "adds book to catalog" do
        assert_equal(Fakes.catalog.count + 1, @catalog.to_a.count)
      end

      test "sets book status to 'active'" do
        expected = Fakes.book_params.merge('status' => 'active').extend(CoreExt::HashExt).symbolize_keys
        assert_include(@catalog, expected)
      end

      test "does not call error handler block" do
        assert_nil(@my_errors, "expected 'my_errors' to be nil")
      end
    end

    context "book params are not valid" do
      setup do
        @invalid_params = Fakes.book_params('title' => '')
        @catalog = Fakes.catalog

        @my_errors = nil
        command = AddBookToCatalog.new(@catalog, @invalid_params) do |errors|
          @my_errors = errors
        end

        command.call
      end

      test "does not add book to catalog" do
        expected = @invalid_params.extend(CoreExt::HashExt).symbolize_keys
        refute_includes(@catalog, expected)
      end

      test "calls error handler block" do
        assert_equal(['title cannot be blank'], @my_errors.to_a)
      end
    end

    test "AddBookToCatalog#call initializes add calls command" do
      catalog = Fakes.catalog

      AddBookToCatalog.call(catalog, Fakes.book_params)

      expected = Fakes.book_params.merge('status' => 'active').extend(CoreExt::HashExt).symbolize_keys
      assert_include(catalog, expected)
    end
  end
end
