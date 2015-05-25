require "rspec/core/rake_task"
require "bundler/gem_tasks"

RSpec::Core::RakeTask.new(:spec)
task :default => :spec

namespace :db do
  desc "Reset database"
  task :reset do
    File.write('scores.db', Marshal.dump([])) if File.exists?('scores.db')
  end

  desc "Remove database file"
  task :remove do
    rm_rf 'scores.db'
  end
end