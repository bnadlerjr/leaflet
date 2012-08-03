require_relative '../../test_helper'
require_relative '../../../lib/leaflet/core_ext/hash_ext'

module Leaflet
  module CoreExt
    class HashExtTest < Test::Unit::TestCase
      setup do
        @target = {
          'foo' => 1,
          'bar' => 2,
          'baz' => 3
        }.extend(HashExt)
      end

      test "symbolize keys destructively in place" do
        @target.symbolize_keys!

        assert_equal({ :foo => 1, :bar => 2, :baz => 3 }, @target)
      end

      test "symbolize keys non-destructively" do
        result = @target.symbolize_keys

        assert_equal({ 'foo' => 1, 'bar' => 2, 'baz' => 3 }, @target)
        assert_equal({ :foo => 1, :bar => 2, :baz => 3 }, result)
      end
    end
  end
end