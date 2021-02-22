# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'coveralls'
require 'simplecov'
require 'simplecov-console'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::Console,
    Coveralls::SimpleCov::Formatter
  ]
)
SimpleCov.start do
  add_filter 'bin'
  add_filter 'features'
  add_filter 'spec'
  add_filter 'pkg'
  add_filter 'templates'
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:expect]
  end

  config.mock_with :rspec do |c|
    c.syntax = [:expect]
  end
end

require 'contur'
