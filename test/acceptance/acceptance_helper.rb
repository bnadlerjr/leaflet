require_relative "../test_helper"
require "capybara"
require "capybara/dsl"
require 'sequel'
require 'sequel/extensions/migration'

class AcceptanceTest < Test::Unit::TestCase
  include Capybara::DSL

  setup do
    Capybara.app = Leaflet::Server
    Capybara.app.set :catalog, database[:books]
  end

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  private

  def database
    @database ||= Sequel.sqlite.tap do |db|
      Sequel::Migrator.run(db, 'db/migrate')
      Fakes.catalog.each { |b| db[:books] << b }
    end
  end
end
