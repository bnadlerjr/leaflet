require 'validus'

module Leaflet
  class BookValidator
    include Validus

    attr_accessor :title, :description, :price

    def initialize(attributes)
      @title = attributes['title']
      @description = attributes['description']
      @price = attributes['price']
    end

    def validate
      errors.add(:title, 'cannot be blank') if title.nil? || '' == title
      errors.add(:description, 'cannot be blank') if description.nil? || '' == description
      validate_price
    end

    private

    def validate_price
      numeric_price = Float(price)
      errors.add(:price, 'cannot be less than zero') if numeric_price < 0
    rescue ArgumentError
      errors.add(:price, 'must be a number')
    end
  end
end