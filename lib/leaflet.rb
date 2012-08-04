require "sinatra/base"
require "sinatra/flash"

require_relative 'leaflet/book_validator'
require_relative 'leaflet/authorization'
require_relative 'leaflet/core_ext/hash_ext'

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
      catalog = if authorization.admin?
        settings.catalog.to_enum
      else
        settings.catalog.find_all do |book|
          book[:status] == 'active'
        end.to_enum
      end

      haml :'books/index', :locals => { :catalog => catalog }
    end

    get '/books/new' do
      authorization.protect do
        haml :'books/new', :locals => { :errors => nil }
      end
    end

    post '/books' do
      authorization.protect do
        validator = BookValidator.new(params['book'])
        if validator.valid?
          flash['notice'] = 'Successfully added book.'
          settings.catalog << params['book'].merge('status' => 'active').extend(CoreExt::HashExt).symbolize_keys!
          redirect to('/')
        else
          haml :'books/new', :locals => { :errors => validator.errors.full_messages }
        end
      end
    end
  end
end