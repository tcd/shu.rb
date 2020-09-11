require "test_helper"
require "rubygems"

module Test
  module Shu
    class VersionTest < Minitest::Test

      test "that it has a version number" do
        refute_nil(::Shu::VERSION)
      end

      test "VERSION" do
        spec_path = File.join(File.expand_path("../../..", __FILE__), "shu.gemspec")
        spec      = Gem::Specification.load(spec_path)
        assert_equal(::Shu::VERSION, spec.version.to_s)
      end

      test "that the readme links to correct version of the docs" do
        search_string = "[docs]: https://www.rubydoc.info/gems/shu/#{::Shu::VERSION}"
        readme        = File.read(File.join(File.expand_path("../../..", __FILE__), "README.md"))
        assert(readme.include?(search_string))
      end

    end
  end
end
