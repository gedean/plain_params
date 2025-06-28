Gem::Specification.new do |s|
  s.name          = 'plain_params'
  s.version       = '0.0.5'
  s.date          = '2025-06-28'
  s.platform      = Gem::Platform::RUBY
  s.summary       = 'Lightweight parameter validation using ActiveModel'
  s.description   = 'A simple and lightweight parameter validation library that leverages ActiveModel ' \
                    'to provide a clean interface for handling parameters with real and virtual fields.'
  s.authors       = ['Gedean Dias']
  s.email         = 'gedean.dias@gmail.com'
  s.files         = Dir['README.md', 'CHANGELOG.md', 'LICENSE', 'lib/**/*', 'examples/**/*']
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 3.0'
  s.homepage      = 'https://github.com/gedean/plain_params'
  s.license       = 'MIT'
  s.add_dependency 'activemodel', '>= 7.0', '< 9.0'
  s.add_development_dependency 'rspec', '~> 3.13'
  s.add_development_dependency 'rake', '~> 13.0'
  s.post_install_message = %q{Thank you for installing PlainParams! Check out the README for usage examples.}
end
