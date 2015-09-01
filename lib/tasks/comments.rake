namespace :comments do
  desc 'update old commments state to published'
  task :update_state_to_published => :environment do
    comments =  Comment.reviewing.where.not("content like '%http%' or content like '%www%' or content like '%.com%' ")
    comments.update_all(state: 'published')
  end
end