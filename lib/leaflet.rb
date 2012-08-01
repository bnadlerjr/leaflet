require "sinatra/base"
require "sinatra/flash"

module Leaflet
  class Server < Sinatra::Base
    enable :sessions
    register Sinatra::Flash

    get '/' do
      @catalog = settings.catalog.find_all do |book|
        book['status'] == 'active'
      end.to_enum

      haml :catalog
    end

    get '/books/new' do
      haml :new_book
    end

    post '/books' do
      if params['book']['title'] == ''
        flash['notice'] = 'There were errors that prevented the book from being added.'
        @errors = ['title cannot be blank']
        haml :new_book
      else
        flash['notice'] = 'Successfully added book.'
        settings.catalog << params['book'].merge('status' => 'active')
        redirect '/'
      end
    end
  end
end