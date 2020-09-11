require "simplecov"

formatters = [SimpleCov::Formatter::HTMLFormatter]
if ENV["CI"] == "true"
  require "coveralls"
  formatters << Coveralls::SimpleCov::Formatter
end
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(formatters)
SimpleCov.start()

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "shu"

require "minitest/autorun"
require "minitest/declarative"
require "minitest/reporters"
Minitest::Reporters.use!([
  # Minitest::Reporters::DefaultReporter.new(color: true),
  Minitest::Reporters::SpecReporter.new,
])
require "pry"
require "vcr"

# Return path of a file to be used in tests.
#
# Only works when tests are run from the project root.
#
# @param path [Pathname]
def file_fixture(path)
  return File.expand_path(File.join(File.dirname(__dir__), "test", "fixtures", path))
end

# Docs - https://relishapp.com/vcr/vcr/v/5-1-0/docs/getting-started
# https://fabioperrella.github.io/10_tips_to_help_using_the_VCR_gem_in_your_ruby_test_suite.html
# https://www.rubyguides.com/2018/12/ruby-vcr-gem/
VCR.configure do |c|
  c.cassette_library_dir = File.expand_path(File.join(File.dirname(__dir__), "test", "fixtures", "cassettes"))
  c.ignore_localhost = true
  c.allow_http_connections_when_no_cassette = false
  c.hook_into(:webmock)
  c.default_cassette_options = {
    record: :new_episodes,
  }
end
