module Shu

  # Errors raised by Shu inherit from {Shu::Error}.
  class Error < StandardError; end

  # Raised when a url isn't a valid GitHub issue or pull request.
  class InvalidGitHubUrlError < Error; end

  # Raised when an attempt is made to add an issue that is already tracked.
  class DuplicateError < Error; end

end
