require 'rubygems'
require 'rake'

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |t|
  #t.test_files = FileList['test/test_*.rb']
  t.ruby_opts << "-Ilib" # in order to use this rcov
  t.ruby_opts << "-Itest"
  t.rcov_opts << "--xrefs"  # comment to disable cross-references
  t.rcov_opts << "--exclude-only" << "test/test*,^\/,^features\/,^widgets\/,test/helper.rb,test/mock_driver.rb"
  t.verbose = true
end

task :build do
  unless system "gem build test_right.gemspec"
    raise "Failed to build"
  end
end

desc 'Release gem to rubygems.org'
task :release => :build do
  system "gem push `ls *.gem | sort | tail -n 1`"
end

desc 'tag current version'
task :tag do
  version = nil
  File.open("test_right.gemspec").each do |line|
    if line =~ /s.version = "(.*)"/
      version = $1
    end
  end

  if version.nil?
    raise "Couldn't find version"
  end

  system "git tag v#{version}"
end

desc 'push to github'
task :push do
  system "git push origin master --tags"
end

task :default => [:test, :tag, :push]
