# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'transilator/version'

Gem::Specification.new do |spec|
  spec.name          = "transilator"
  spec.version       = Transilator::VERSION
  spec.authors       = ['Hendrik Kleinwaechter']
  spec.email         = ['hendrik.kleinwaechter@gmail.com']

  spec.summary       = %q{Fast and efficient model translations in the database for PostgreSQL hstore and JSON}
  spec.description   = %q{Fast and efficient model translations in the databse for PostgreSQL hstore and JSON.}
  spec.homepage      = "https://github.com/hendricius/transilator"
  spec.licenses      = ['MIT']

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', "~> 1.10"
  spec.add_development_dependency 'rake', "~> 10.0"
  spec.add_development_dependency 'minitest', "~> 5.0"
  spec.add_development_dependency 'pry', "~> 0.1"

  spec.add_dependency 'activerecord', '~> 5.0'
  spec.add_dependency 'pg', '~> 0.19'
end
