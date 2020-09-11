require "test_helper"
require "rubygems"

module Test
  module Shu
    class VersionTest < Minitest::Test

      def test_that_it_has_a_version_number
        refute_nil(::Shu::VERSION)
      end

      def test_that_versions_match
        spec_path = File.join(File.expand_path("../../..", __FILE__), "shu.gemspec")
        spec      = Gem::Specification.load(spec_path)
        assert_equal(::Shu::VERSION, spec.version.to_s)
      end

      def test_readme_links_to_correct_version
        search_string = "[docs]: https://www.rubydoc.info/gems/shu/#{::Shu::VERSION}"
        readme        = File.read(File.join(File.expand_path("../../..", __FILE__), "README.md"))
        assert(readme.include?(search_string))
      end

    end
  end
end
