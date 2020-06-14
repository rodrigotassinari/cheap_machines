require_relative 'lib/cheap_machines/version'

Gem::Specification.new do |spec|
  spec.name          = "cheap_machines"
  spec.version       = CheapMachines::VERSION
  spec.authors       = ["Rodrigo Tassinari de Oliveira"]
  spec.email         = ["rodrigo@tassinari.eti.br"]

  spec.summary       = %q{Ruby gem and CLI to manage cheap persistent instances for remote development on AWS EC2.}
  spec.description   = %q{Ruby gem and CLI to manage cheap persistent instances for remote development on AWS EC2.}
  spec.homepage      = "https://github.com/rodrigotassinari/cheap_machines"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/rodrigotassinari/cheap_machines"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  
  spec.add_runtime_dependency "zeitwerk", "~> 2.3"
  spec.add_runtime_dependency "aws-sdk-ec2", "~> 1.163"
  spec.add_runtime_dependency "dry-transaction", "~> 0.13"
  
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "minitest", "~> 5.14"
  spec.add_development_dependency "vcr", "~> 5.1"
  spec.add_development_dependency "minitest-vcr", "~> 1.4"
  spec.add_development_dependency "webmock", "~> 3.8"
  spec.add_development_dependency "mocha", "~> 1.11"
  spec.add_development_dependency "spy", "~> 1.0"
  spec.add_development_dependency "guard", "~> 2.16"
  spec.add_development_dependency "guard-minitest", "~> 2.4"
  spec.add_development_dependency "minitest-reporters", "~> 1.4"
  spec.add_development_dependency "simplecov", "~> 0.18"
  spec.add_development_dependency "timecop", "~> 0.9"
end
