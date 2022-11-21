require "bundler"
Bundler::GemHelper.install_tasks name: "rocketmq-client-ruby"

# require "bundler/gem_tasks"
require "rake/testtask"

begin
  require "chefstyle"
  require "rubocop/rake_task"
  desc "Run Chefstyle tests"
  RuboCop::RakeTask.new(:style) do |task|
    task.options += ["--display-cop-names", "--no-color"]
  end
rescue LoadError
  puts "chefstyle gem is not installed. bundle install first to make sure all dependencies are installed."
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/test_rocketmq-client-ruby.rb"]
end

desc "Run style & unit tests on Travis"
task travis: %w{test style}

# Default
desc "Run style, unit"
task default: %w{test style}
