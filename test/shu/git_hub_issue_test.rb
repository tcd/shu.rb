require "test_helper"

module Test
  module Shu
    class GitHubIssueTest < Minitest::Test

      setup do
        @issue_url = "https://github.com/tcd/ginny/issues/2"
        @pull_request_url = "https://github.com/tcd/ginny/pull/3"
        # @type [Shu::GitHubIssue]
        @issue = ::Shu::GitHubIssue.create(
          repo_owner: "tcd",
          repo_name:  "ginny",
          number:     2,
          title:      "Add option to output YARD attribute macros",
        )
      end

      # ========================================================================
      # Class Methods
      # ========================================================================

      test ".create" do
        issue = ::Shu::GitHubIssue.create(
          repo_owner: "tcd",
          repo_name:  "ginny",
          number:     2,
        )
        refute_nil(issue)
      end

      test ".create only accepts valid arguments" do
        assert_raises(ArgumentError) do
          ::Shu::GitHubIssue.create(
            repo_owner: "tcd",
            repo_name:  "ginny",
            number:     2,
            some_crazy_thing: 420,
          )
        end
      end

      test ".defaults" do
        issue = ::Shu::GitHubIssue.create(
          repo_owner: "tcd",
          repo_name:  "ginny",
          number:     2,
          closed:     false,
        )
        assert_instance_of(Time, issue.shu_created_at)
        assert_nil(issue.shu_updated_at)
        assert_equal(false, issue.pull_request)
        assert_equal(false, issue.closed)
      end

      test ".parse_url raises if there are no matches" do
        assert_raises(::Shu::InvalidGitHubUrlError) do
          ::Shu::GitHubIssue.parse_url("https://github.com/owner/repo/x/69")
        end
      end

      test ".parse_url returns appropreate MatchData" do
        owner, repo, number, type = ::Shu::GitHubIssue.parse_url(@issue_url)
        refute_nil(owner)
        refute_nil(repo)
        refute_nil(type)
        refute_nil(number)
      end

      test ".create_from_url issue" do
        VCR.use_cassette("issue") do
          shu = ::Shu::GitHubIssue.create_from_url(@issue_url)
          refute_nil(shu.title)
          refute_nil(shu.created_at)
          refute_nil(shu.updated_at)
          assert_equal(false, shu.closed)
        end
      end

      test ".create_from_url pull_request" do
        VCR.use_cassette("pull_request") do
          shu = ::Shu::GitHubIssue.create_from_url(@pull_request_url)
          refute_nil(shu.title)
          refute_nil(shu.created_at)
          refute_nil(shu.updated_at)
          assert_equal(false, shu.closed)
        end
      end

      # ========================================================================
      # Instance Methods
      # ========================================================================

      test "#to_s" do
        assert_equal("tcd/ginny - issue #2 - Add option to output YARD attribute macros", @issue.to_s())
      end

      test "#url" do
        assert_equal("https://github.com/tcd/ginny/issues/2", @issue.url())
      end

      test "#repo" do
        assert_equal("tcd/ginny", @issue.repo())
      end

      test "#repo_url" do
        assert_equal("https://github.com/tcd/ginny", @issue.repo_url())
      end

    end
  end
end
