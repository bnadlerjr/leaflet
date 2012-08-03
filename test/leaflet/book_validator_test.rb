require_relative '../test_helper'

require_relative '../../lib/leaflet/book_validator'

module Leaflet
  class BookValidatorTest < Test::Unit::TestCase
    test "is valid when all attributes are valid" do
      validator = BookValidator.new(Fakes.book_params)
      assert(validator.valid?, 'expected validator to be valid')
      assert(validator.errors.empty?, 'expected validator errors to be empty')
    end

    test "is invalid without title" do
      params = Fakes.book_params('title' => '')
      validator = BookValidator.new(params)
      refute(validator.valid?, 'expected validator to be invalid without title')
      assert_equal(['cannot be blank'], validator.errors.for(:title).to_a)
    end

    test "is invalid without description" do
      params = Fakes.book_params('description' => '')
      validator = BookValidator.new(params)
      refute(validator.valid?, 'expected validator to be invalid without description')
      assert_equal(['cannot be blank'], validator.errors.for(:description).to_a)
    end

    test "is invalid if price is not a number" do
      params = Fakes.book_params('price' => '')
      validator = BookValidator.new(params)
      refute(validator.valid?, 'expected validator to be invalid if price is not a number')
      assert_equal(['must be a number'], validator.errors.for(:price).to_a)
    end

    test "is invalid if price is less than zero" do
      params = Fakes.book_params('price' => '-9.50')
      validator = BookValidator.new(params)
      refute(validator.valid?, 'expected validator to be invalid if price is less than zero')
      assert_equal(['cannot be less than zero'], validator.errors.for(:price).to_a)
    end
  end
end