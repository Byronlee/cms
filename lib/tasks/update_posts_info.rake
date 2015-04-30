namespace :update_post_attr do
  desc 'update post favoriter sso ids'
  task :favoriter_sso_ids => :environment do
    total_count = Post.count
    Post.order("url_code desc").each_with_index do |post, index|

      favoriter_sso_ids = 
        post.favoriters.includes(:krypton_authentication).
        select{ |user| user.krypton_authentication.present? }.
        map{ |user| user.krypton_authentication.uid.to_i }

      post.update_column(:favoriter_sso_ids, favoriter_sso_ids.uniq) if favoriter_sso_ids.uniq.present?
      puts "[#{index + 1}/#{total_count}][#{Time.now}]post##{post.url_code}.favoriter_sso_ids => #{favoriter_sso_ids}"
    end
  end
end