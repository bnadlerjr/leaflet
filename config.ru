require "bundler/setup"
require "sprockets"
require File.join(File.dirname(__FILE__), "lib/leaflet")

map '/assets' do
  env = Sprockets::Environment.new
  %w(js css vendor).each { |dir| env.append_path("lib/assets/#{dir}") }
  env.append_path("lib/assets/vendor/jquery-ui-1.8.22.custom/css/humanity")
  run env
end

require "csv"
opts = {
  :headers    => true,
  :converters => :all
}
books = CSV.read("./data/books.csv", opts).map { |row| row.to_hash }

app = Leaflet::Server
app.set :catalog, books
run app