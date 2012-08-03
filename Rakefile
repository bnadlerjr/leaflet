require "rake/testtask"
require "rdoc/task"
require "flay_task"
require "flog"

DEFAULT_TASKS    = %w[test flog flay]
MAIN_RDOC        = 'README.rdoc'
EXTRA_RDOC_FILES = [MAIN_RDOC]
LIB_FILES        = Dir["lib/**/*.rb"]
TEST_FILES       = Dir["test/**/*_test.rb"]
TITLE            = 'Leaflet'

# Import external rake tasks
Dir.glob('tasks/*.rake').each { |r| import r }

desc "Default tasks: #{DEFAULT_TASKS.join(', ')}"
task :default => DEFAULT_TASKS

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = TEST_FILES
end

RDoc::Task.new do |t|
  t.main = MAIN_RDOC
  t.rdoc_dir = 'doc'
  t.rdoc_files.include(EXTRA_RDOC_FILES, LIB_FILES)
  t.options << '-q'
  t.title = TITLE
end

FlayTask.new do |t|
  t.dirs = %w[lib]
end

desc 'Analyze code using ABC metric'
task :flog do
  flog = Flog.new
  flog.flog ['lib']
  threshold = 50

  bad_methods = flog.totals.select do |name, score|
    score > threshold
  end

  bad_methods.sort do |a, b|
    a[1] <=> b[1]
  end.each do |name, score|
    puts "%8.1f: %s" % [score, name]
  end

  unless bad_methods.empty?
    raise "#{bad_methods.size} methods have a flog complexity > #{threshold}"
  end
end
