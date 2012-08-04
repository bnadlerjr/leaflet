require "csv"
require 'sequel'

namespace :db do
  desc 'Load data from CSV file into database'
  task :seed do
    url = ENV['DATABASE_URL'] || 'sqlite://db/development.sqlite3'
    DB = Sequel.connect(url)
    opts = { :headers => true, :converters => :all }
    CSV.read("./data/books.csv", opts).map { |row| DB[:books] << row.to_hash }
  end
end