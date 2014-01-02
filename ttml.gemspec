# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ttml/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Luca S.G. de Marinis"]
  gem.email         = ["loop23@gmail.com"]
  gem.description   = %q{Parse a ttml file}
  gem.summary       = %q{Minimal parsing for timed text markup language (http://www.w3.org/TR/ttaf1-dfxp/)}
  gem.homepage      = "http://github.com/loop23/ttml"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ttml"
  gem.require_paths = ["lib"]
  gem.version       = Ttml::VERSION

  gem.add_runtime_dependency "nokogiri"
  gem.add_runtime_dependency "trollop"

end
