require 'rake/testtask'

Rake::TestTask.new do |task|
  task.libs << 'test' # adds the tests directory to the lists of directories in the #$LOADPATH
  task.test_files = FileList['test/*test*.rb']
  # creates a list of files that match "tests/test*.rb"
  task.verbose = true
  # if you want your tests to output what they should do, then set this to true.
end

task 'default' => 'test'

task 'hello' do
  p 'hello world!'
end
