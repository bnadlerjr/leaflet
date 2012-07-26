require "sinatra/base"

module Leaflet
  class Server < Sinatra::Base
    get '/' do
      @catalog = settings.catalog.find_all do |book|
        book['status'] == 'active'
      end.to_enum

      haml :catalog
    end
  end
end