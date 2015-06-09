json.total @favorites.total_count
json.favorites @favorites do |favorit|
  json.url_code  favorit.post.url_code
  json.cover_real_url  favorit.post.cover_real_url
  json.title  favorit.post.title
  json.summary  favorit.post.summary
  json.url  "http://36kr.com/p/#{favorit.post.url_code}.html"
  json.created_at  favorit.created_at.iso8601
  json.updated_at  favorit.updated_at.iso8601
end
