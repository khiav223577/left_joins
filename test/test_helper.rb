require "simplecov"
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'left_joins'

require 'minitest/autorun'
Minitest::Test = MiniTest::Unit::TestCase unless defined? Minitest::Test

ActiveRecord::Base.establish_connection(
  "adapter"  => "sqlite3",
  "database" => ":memory:"
)
require 'seeds'
