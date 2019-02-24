# rubocop:disable Style/SymbolArray
# rubocop:disable Style/HashSyntax

require 'bundler/gem_tasks'

task :validate_gemspec do
  Bundler.load_gemspec('git-switcher.gemspec').validate
end

task :version => :validate_gemspec do
  puts Git::Switcher.version
end

require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop)

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => [:version, :rubocop, :test]

task :documentation

Rake::Task['build'].enhance([:default, :documentation])

# rubocop:enable Style/HashSyntax
# rubocop:enable Style/SymbolArray
