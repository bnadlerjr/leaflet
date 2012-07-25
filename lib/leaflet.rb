require "sinatra/base"

module Leaflet
  class Server < Sinatra::Base
    get '/' do
      "Hello World!"
    end
  end
end