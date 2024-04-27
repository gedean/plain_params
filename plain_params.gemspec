Gem::Specification.new do |s|
  s.name          = 'plain_params'
  s.version       = '0.0.2'
  s.date          = '2024-04-25'
  s.platform      = Gem::Platform::RUBY
  s.summary       = 'No ActiveRecord or Dry-Validation, just plain parameters.'
  s.description   = 'No ActiveRecord or Dry-Validation, just plain parameters.'
  s.authors       = ['Gedean Dias']
  s.email         = 'gedean.dias@gmail.com'
  s.files         = Dir['README.md', 'lib/**/*']
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 3'
  s.homepage      = 'https://github.com/gedean/plain_params'
  s.license       = 'MIT'
  s.add_dependency 'activemodel', '~> 7.1'
  s.post_install_message = %q{Please check readme file for use instructions.}
end
