require File.expand_path('../lib/titleize_pt/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name     = 'titleize_pt'
  gem.version  = TitleizePT::VERSION
  gem.authors  = ['David Francisco']
  gem.email    = 'titleize@dmfranc.com'
  gem.summary  = 'Properly capitalize titles in Portuguese'
  gem.platform = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 1.9.3'

  gem.files = `git ls-files`.split($\)
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake", "~> 10.0.4"
  gem.add_runtime_dependency "activesupport", "~> 3.2.13"
end
