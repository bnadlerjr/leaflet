require "bundler/setup"
require File.join(File.dirname(__FILE__), "lib/leaflet")

require "csv"
opts = {
  :headers    => true,
  :converters => :all
}
books = CSV.read("./data/books.csv", opts).map { |row| row.to_hash }

app = Leaflet::Server
app.set :catalog, books
run app