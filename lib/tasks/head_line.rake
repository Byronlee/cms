namespace :head_lines do
  desc 'flush spotlight meta info'
  task :fetch do
	HeadLinesComponentWorker.new.perform
  end
end