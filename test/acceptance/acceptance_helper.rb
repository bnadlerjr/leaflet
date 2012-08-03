require_relative "../test_helper"
require "capybara"
require "capybara/dsl"

class AcceptanceTest < Test::Unit::TestCase
  include Capybara::DSL

  setup do
    Capybara.app = Leaflet::Server
    Capybara.app.set :catalog, Fakes.catalog
  end

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
