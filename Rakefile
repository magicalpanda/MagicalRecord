@ios_fixtures = "Unit Tests/Fixtures/iOS"


@target   = ""
@project  = ""
@fixtures = ""

namespace :setup do
  task :ios do

  end

  task :osx do
    @target   = "Mac App Unit Tests"
    @project  = "Magical Record.xcodeproj"
    @fixtures = "Unit Tests/Fixtures/Mac"
  end
end

namespace :clean do
  task :osx => ["setup:osx"] do
    rm_rf "#{@fixtures}/TestEntities"
  end
end

namespace :build do

  task :run do
    results = system("xcodebuild -project '#{@project}' -target '#{@target}'")
    puts results
  end

  namespace :db do
    task :create do
      Dir.chdir(@fixtures) do
        puts `/usr/local/bin/mogenerator -m TestModel.xcdatamodeld/TestModel.xcdatamodel -O TestEntities`
      end
    end
  end

  task :osx => ["setup:osx", "clean:osx", "build:db:create", "build:run"] 

  task :ios => [] do

  end
end

namespace :test do
  task :osx => ["build:osx"] do
    puts "testing osx"
  end

  task :ios do
    puts "testing ios"
  end
end

task :test => ["test:osx", "test:ios"]

task :default => :test
