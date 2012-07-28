ENV['RACK_ENV'] = 'test'

require "test/unit"
require "contest"

require 'minitest/reporters'
MiniTest::Reporters.use!
