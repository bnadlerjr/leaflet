require_relative "../test_helper"
require "capybara"
require "capybara/dsl"

class AcceptanceTest < Test::Unit::TestCase
  include Capybara::DSL

  setup do
    Capybara.app = Leaflet::Server

    Capybara.app.set :catalog, [
      { 'title'       => 'The Well-Grounded Rubyist',
        'description' => 'This is an awesome book!',
        'price'       => 44.99,
        'status'      => 'active'
      },
      { 'title'       => 'Eloquent Ruby',
        'description' => 'Another awesome book about Ruby!',
        'price'       => 30.67,
        'status'      => 'inactive'
      }
    ]
  end

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
