require "octokit"

module Shu
  # An issue on GitHub
  class GitHubIssue

    # @return [Regexp]
    URL_PATTERN = %r{https:\/\/github.com\/(?<owner>(?:\w|-)+)\/(?<repo>(?:\w|-)+)\/(?<type>issues|pull)\/(?<number>[0-9]+)}.freeze()

    # ==========================================================================
    # Attributes
    # ==========================================================================

    # @!group Attributes

    # Used internally by Shu
    # @return [Integer]
    attr_accessor :id

    # @return [String]
    attr_accessor :repo_owner

    # @return [String]
    attr_accessor :repo_name

    # @return [Integer]
    attr_accessor :number

    # @return [String]
    attr_accessor :title

    # @return [String]
    attr_accessor :author

    # @return [Boolean]
    attr_accessor :pull_request

    # @return [Boolean]
    attr_accessor :closed

    # @return [Boolean]
    attr_accessor :merged

    # @return [Time]
    attr_accessor :created_at

    # @return [Time]
    attr_accessor :updated_at

    # @return [Time]
    attr_accessor :shu_created_at

    # @return [Time]
    attr_accessor :shu_updated_at

    # Timestamp from when the issue was added to Shu
    # @return [Time]
    attr_accessor :tracked_since

    # @!endgroup Attributes

    # ==========================================================================
    # Class Methods
    # ==========================================================================

    # @return [Hash<Symbol>]
    def self.defaults()
      return {
        pull_request:   false,
        shu_created_at: Time.now(),
        tracked_since:  Time.now(),
      }
    end

    # @param args [Hash]
    # @return [Shu::GitHubIssue]
    def self.create(args = {})
      invalid = self.invalid_keys(args)
      raise ArgumentError, "invalid keys: #{invalid}" if invalid.length > 0

      args = self.defaults().merge(args.compact())
      g    = GitHubIssue.new()

      g.id             = args[:id]
      g.repo_owner     = args[:repo_owner]
      g.repo_name      = args[:repo_name]
      g.number         = args[:number]
      g.title          = args[:title]
      g.author         = args[:author]
      g.pull_request   = args[:pull_request]
      g.closed         = args[:closed]
      g.merged         = args[:merged]
      g.created_at     = args[:created_at]
      g.updated_at     = args[:updated_at]
      g.shu_created_at = args[:shu_created_at]
      g.shu_updated_at = args[:shu_updated_at]
      g.tracked_since  = args[:tracked_since]

      return g
    end

    # Returns a new GitHubIssue from a link to an existing issue.
    # See the GitHub REST API Docs:
    #
    # - [get-a-single-issue](https://docs.github.com/en/rest/reference/issues#get-a-single-issue)
    # - [get-a-single-pull-request](https://docs.github.com/en/rest/reference/pulls#get-a-pull-request)
    #
    # @return [Shu::GitHubIssue]
    def self.create_from_url(url)
      owner, name, number, type = self.parse_url(url)
      repo = [owner, name].join("/")
      is_pull_request = type == "pull"
      res = is_pull_request ? Octokit.pull_request(repo, number) : Octokit.issue(repo, number)
      return self.create(
        pull_request: is_pull_request,
        repo_owner:   owner,
        repo_name:    name,
        number:       number,
        title:        res.title,
        author:       res.user.login,
        created_at:   res.created_at,
        updated_at:   res.updated_at,
        closed:       !res.closed_at.nil?,
        merged:       !res.merged_at.nil?,
      )
    end

    # @param path [String,Pathname]
    # @return [Array<Shu::GitHubIssue>]
    def self.read_from_file(path)
      raise NotImplementedError
    end

    # @param path [String,Pathname]
    # @return [void]
    def self.write_to_file(url)
      raise NotImplementedError
    end

    # @param url [String]
    # @return [String, String, String String] owner, repo, number, type
    def self.parse_url(url)
      if (matches = url.match(URL_PATTERN))
        return matches[:owner], matches[:repo], matches[:number], matches[:type]
      end
      raise Shu::InvalidGitHubUrlError
    end

    # @param hash [Array<Symbol>]
    # @return [Array<Symbol>]
    def self.invalid_keys(hash)
      raise ArgumentError unless hash.is_a?(Hash)
      attr_readers = (new().methods - Object.methods).reject { |m| m.to_s.include?("=") }
      return (hash.keys - attr_readers)
    end

    # ==========================================================================
    # Instance Methods
    # ==========================================================================

    # @return [String]
    def to_s()
      type = pull_request ? "pull request" : "issue"
      return "#{repo()} - #{type} ##{number} - #{title}"
    end

    # @return [String]
    def url()
      type = pull_request ? "pull" : "issues"
      return "#{repo_url()}/#{type}/#{number}"
    end

    # @return [String]
    def repo()
      return [repo_owner, repo_name].join("/")
    end

    # @return [String]
    def repo_url()
      return "https://github.com/#{repo()}"
    end

  end
end
