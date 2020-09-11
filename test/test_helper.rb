require "simplecov"

formatters = [SimpleCov::Formatter::HTMLFormatter]
if ENV["CI"] == "true"
  require "coveralls"
  formatters << Coveralls::SimpleCov::Formatter
end
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(formatters)
SimpleCov.start()

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "shu"

require "minitest/autorun"
require "minitest/reporters"
Minitest::Reporters.use!([
  # Minitest::Reporters::DefaultReporter.new(color: true),
  Minitest::Reporters::SpecReporter.new,
])

# Return path of a file to be used in tests.
#
# Only works when tests are run from the project root.
#
# @param path [Pathname]
def file_fixture(path)
  return File.expand_path(File.join(File.dirname(__dir__), "test", "fixtures", path))
end
