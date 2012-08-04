require "sinatra/base"
require "sinatra/flash"

require_relative 'leaflet/book_validator'
require_relative 'leaflet/core_ext/hash_ext'

module Leaflet
  class Server < Sinatra::Base
    enable :sessions
    register Sinatra::Flash

    helpers do
      def authorized?
        @auth ||= Rack::Auth::Basic::Request.new(env)
        @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['admin', 'secret']
      end

      def protected!
        unless authorized?
          response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
          throw(:halt, [401, "Not authorized\n"])
        end
      end
    end

    get '/' do
      catalog = if authorized?
        settings.catalog.to_enum
      else
        settings.catalog.find_all do |book|
          book[:status] == 'active'
        end.to_enum
      end

      haml :'books/index', :locals => { :catalog => catalog }
    end

    get '/books/new' do
      protected!
      haml :'books/new', :locals => { :errors => nil }
    end

    post '/books' do
      protected!
      validator = BookValidator.new(params['book'])
      if validator.valid?
        flash['notice'] = 'Successfully added book.'
        settings.catalog << params['book'].merge('status' => 'active').extend(CoreExt::HashExt).symbolize_keys!
        redirect '/'
      else
        haml :'books/new', :locals => { :errors => validator.errors.full_messages }
      end
    end
  end
end