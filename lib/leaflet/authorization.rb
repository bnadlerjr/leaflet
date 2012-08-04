module Leaflet
  class Authorization
    def initialize(env, &block)
      raise(ArgumentError, "'not authorized' block is required") unless block_given?
      @auth =  Rack::Auth::Basic::Request.new(env)
      @not_authorized_block = block
    end

    def admin?
      @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['admin', 'secret']
    end

    def protect
      @not_authorized_block.call unless admin?
      yield
    end
  end
end