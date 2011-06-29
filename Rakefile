require 'bundler'
Bundler::GemHelper.install_tasks
require 'rake/testtask'
desc "Default Task"
Rake::TestTask.new do |t|
  files = FileList['test/test_helper.rb', 'test/**/*test.rb']
  t.test_files = files
  t.libs << "test"
#  t.warning = true
end
task :default => :test
