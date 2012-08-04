require_relative '../test_helper'
require_relative '../../lib/leaflet/view_catalog'

module Leaflet
  class ViewCatalogTest < Test::Unit::TestCase
    test "returns all books in catalog if admin" do
      catalog = Fakes.catalog
      command = ViewCatalog.new(stub(:admin? => true), catalog)
      assert_equal(catalog, command.call.to_a)
    end

    test "returns only active books if not an admin" do
      command = ViewCatalog.new(stub(:admin? => false), Fakes.catalog)
      expected = Fakes.catalog.find_all { |b| b[:status] == 'active' }
      assert_equal(expected, command.call.to_a)
    end

    test "ViewCatalog#call initializes and calls command" do
      catalog = Fakes.catalog
      assert_equal(catalog, ViewCatalog.call(stub(:admin? => true), catalog).to_a)
    end
  end
end
