# frozen_string_literal: true

require "simplecov"

SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter]
SimpleCov.minimum_coverage 70.0

SimpleCov.start do
  add_filter "/spec/"
  minimum_coverage 70
  minimum_coverage_by_file 40
end

require "bundler"
require "pry"
require "rubygems"
require "webmock/rspec"
require "zaig"

begin
  Bundler.setup(:default, :development, :test)
rescue Bundler::BundlerError => e
  warn e.message
  warn "Run `bundle install` to install missing gems"

  exit e.status_code
end

ENV["RACK_ENV"] = "test"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
    c.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.example_status_persistence_file_path = "tmp/spec/examples.txt"
end

def expect_to_have_http_status(status)
  yield
  expect(response).to have_http_status status
end

def parsed_response
  yield if block_given?
  JSON.parse(response.body, symbolize_names: true)
end

def expect_parsed_response
  expect(parsed_response { yield if block_given? })
end

# minitest/mock # Uncomment me to use minitest mocks
