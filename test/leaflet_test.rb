ENV['RACK_ENV'] = 'test'

require "test/unit"
require "contest"

require 'minitest/reporters'
MiniTest::Reporters.use!

require "rack/test"

require_relative "../lib/leaflet"

module Leaflet
  class ServerTest < Test::Unit::TestCase
    include Rack::Test::Methods

    test "hookup" do
      get '/'
      assert_response(:ok)
      assert_body_contains("Hello World!")
    end

    private

    def app
      Leaflet::Server
    end

    def assert_response(expected, message=nil)
      msg = build_message(message, "expected last response to be <?> but was <?>", expected, last_response.status)
      assert_block(msg) do
        last_response.send("#{expected}?")
      end
    end

    def assert_body_contains(expected, message=nil)
      msg = build_message(message, "expected body to contain <?>\n#{last_response.body}", expected)
      assert_block(msg) do
        last_response.body.include?(expected)
      end
    end
  end
end