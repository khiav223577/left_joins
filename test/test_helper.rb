require 'simplecov'
SimpleCov.start 'test_frameworks'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'left_joins'
require 'minitest/autorun'
Minitest::Test = MiniTest::Unit::TestCase unless defined? Minitest::Test

require 'lib/sqlite3_connection'
require 'lib/seeds'
