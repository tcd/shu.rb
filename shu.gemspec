require_relative "lib/shu/version"

Gem::Specification.new do |spec|
  spec.name          = "shu"
  spec.version       = Shu::VERSION
  spec.authors       = ["Clay Dunston"]
  spec.email         = ["dunstontc@gmail.com"]
  spec.summary       = "Track issues on GitHub and GitLab."
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/tcd/shu.rb"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata = {
    "homepage_uri"      => spec.homepage,
    "source_code_uri"   => spec.homepage,
    "changelog_uri"     => "#{spec.homepage}/blob/master/CHANGELOG.md",
    "documentation_uri" => "https://www.rubydoc.info/gems/#{spec.name}/#{spec.version}",
    "yard.run"          => "yri", # use "yard" to build full HTML docs.
  }

  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "coveralls", "~> 0.8.23"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters", "~> 1.4"
  spec.add_development_dependency "pry", "~> 0.12.2"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "simplecov", "~> 0.16"
end
