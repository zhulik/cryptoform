# frozen_string_literal: true

require_relative "lib/cryptoform/version"

Gem::Specification.new do |spec|
  spec.name = "cryptoform"
  spec.version = Cryptoform::VERSION
  spec.authors = ["Gleb Sinyavskiy"]
  spec.email = ["zhulik.gleb@gmail.com"]

  spec.summary = "Save your encypted terraform state in git."
  spec.description = "Save your encypted terraform state in git."
  spec.homepage = "https://github.com/zhulik/cryptoform"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/zhulik/cryptoform/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "base64", "~> 0.2"
  spec.add_dependency "lockbox", "~> 1.3"
  spec.add_dependency "rackup", "~> 2.1"
  spec.add_dependency "sinatra", "~> 4.0"
  spec.add_dependency "sinatra-contrib", "~> 4.0"
  spec.add_dependency "webrick", "~> 1.8"
  spec.add_dependency "zeitwerk", "~> 2.6"

  spec.metadata["rubygems_mfa_required"] = "true"
end
