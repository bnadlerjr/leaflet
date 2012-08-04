require "sinatra/base"
require "sinatra/flash"

require_relative 'leaflet/authorization'
require_relative 'leaflet/view_catalog'
require_relative 'leaflet/add_book_to_catalog'

module Leaflet
  class Server < Sinatra::Base
    enable :sessions
    register Sinatra::Flash

    helpers do
      def authorization
        @authorization ||= Authorization.new(env) do
          response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
          throw(:halt, [401, "Not authorized\n"])
        end
      end
    end

    get '/' do
      catalog = ViewCatalog.call(authorization, settings.catalog)
      haml :'books/index', :locals => { :catalog => catalog }
    end

    get '/books/new' do
      authorization.protect do
        haml :'books/new', :locals => { :errors => nil }
      end
    end

    post '/books' do
      authorization.protect do
        AddBookToCatalog.call(settings.catalog, params['book']) do |errors|
          halt haml(:'books/new', :locals => { :errors => errors })
        end

        flash['notice'] = 'Successfully added book.'
        redirect to('/')
      end
    end
  end
end