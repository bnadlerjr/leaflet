module Leaflet
  class ViewCatalog
    def self.call(auth, catalog)
      self.new(auth, catalog).call
    end

    def initialize(auth, catalog)
      @auth = auth
      @catalog = catalog
    end

    def call
      if @auth.admin?
        @catalog.to_enum
      else
        @catalog.find_all do |book|
          book[:status] == 'active'
        end.to_enum
      end
    end
  end
end