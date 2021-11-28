# frozen_string_literal: true

require 'rake/testtask'

task default: :test

desc 'Run all tests'
Rake::TestTask.new do |task|
  task.pattern = 'spec/**/*_spec.rb'
  task.warning = false
end

namespace :test do
  Dir.glob("#{__dir__}/spec/*").each do |e|
    next unless File.directory?(e)

    ns = File.basename(e).to_sym
    desc "Run #{ns} tests"
    Rake::TestTask.new ns do |task|
      task.pattern = "#{e}/*_spec.rb"
      task.warning = false
    end
  end
end
