require "bundler/setup"
require "sprockets"
require File.join(File.dirname(__FILE__), "lib/leaflet")

map '/assets' do
  env = Sprockets::Environment.new
  %w(js css vendor).each { |dir| env.append_path("lib/assets/#{dir}") }
  env.append_path("lib/assets/vendor/jquery-ui-1.8.22.custom/css/humanity")
  run env
end

require 'sequel'
url = ENV['DATABASE_URL'] || 'sqlite://db/development.sqlite3'
DB = Sequel.connect(url)
Sequel.extension :migration
Sequel::Migrator.check_current(DB, 'db/migrate')

app = Leaflet::Server
app.set :catalog, DB[:books]
run app