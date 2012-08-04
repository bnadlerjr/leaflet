require_relative 'book_validator'
require_relative 'core_ext/hash_ext'

module Leaflet
  class AddBookToCatalog
    def self.call(catalog, params, &block)
      self.new(catalog, params, &block).call
    end

    def initialize(catalog, params, &block)
      @catalog = catalog
      @params = params
      @error_handler = block
    end

    def call
      validator = BookValidator.new(@params)
      if validator.valid?
        @catalog << @params.merge('status' => 'active').extend(CoreExt::HashExt).symbolize_keys
      else
        @error_handler.call(validator.errors.full_messages)
      end
    end
  end
end