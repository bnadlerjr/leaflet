ENV['RACK_ENV'] = 'test'

require "test/unit"
require "contest"
require "mocha"

require 'minitest/reporters'
MiniTest::Reporters.use!

require_relative 'support/fakes'
