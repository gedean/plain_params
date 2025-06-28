require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc "Run example scripts"
task :examples do
  Dir['examples/*.rb'].each do |file|
    puts "\n=== Running #{file} ==="
    system("ruby #{file}")
  end
end

desc "Build gem"
task :build do
  system("gem build plain_params.gemspec")
end

desc "Install gem locally"
task install: :build do
  system("gem install plain_params-*.gem")
end 