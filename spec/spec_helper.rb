# coding: utf-8

require 'bundler'
require 'fakefs/spec_helpers'
require 'simplecov'
require 'coveralls'

Bundler.setup(:default, :development)

RSpec.configure do |config|
  config.color = true
  config.tty = true
  #config.formatter = :documentation
  config.include FakeFS::SpecHelpers, fakefs: true
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
 add_filter '/spec/'
end
