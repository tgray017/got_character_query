
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "got_character_query/version"

Gem::Specification.new do |spec|
  spec.name          = "got_character_query"
  spec.version       = GotCharacterQuery::VERSION
  spec.authors       = ["'Thomas Gray'"]
  spec.email         = ["'tgray017@gmail.com'"]

  spec.summary       = %q{GoT Character Query}
  spec.description   = %q{List Game of Thrones characters and get more info on each.}
  spec.homepage      = "https://github.com/tgray017/got_character_query"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"

  spec.add_dependency "nokogiri"
  spec.add_dependency "colorize"
end
