module V1
  module Controllers
    class Weibo < ::V1::Base
      format :json

      resource :linkcard do

        desc 'weibo linkcard'
        params do
          optional :url,  type: String, desc: 'url'
        end
        get "topics" do
          url = params[:url]
          uri = url.scan(URI.regexp)
          #pid = uri[0][6].match(/\d+/)[0].to_i
          match_uri = uri[0][6].match(/^\/p\/(\d+)/)
          unless match_uri.nil?
            pid = match_uri[1].to_i
            @post = Post.find_by_url_code pid
            cache(key: "api:v1:weibo:linkcard", etag: Time.now, expires_in: Settings.api.expires_in) do
              if !@post.nil? && @post.state == "published"
                {
                  "display_name" => "#{@post.title}",
                  "image" =>  {
                  "url" => "#{@post.cover_real_url}!s2",
                  "width" => 120,
                  "height" =>  120
                },
                  "author" =>  {
                  "display_name" =>  "#{@post.author.name||"36Kr"}",
                  "url" => "#{Settings.site}",
                  "object_type" =>  "person"
                },
                  "summary" =>  "#{@post.summary||""}",
                  "url" =>  "#{Settings.site}/p/#{@post.url_code}.html",
                "links" =>  {
                  "url" =>  "#{Settings.site}/p/#{@post.url_code}.html",
                  "scheme" =>  "scheme://www.36kr.com/p/#{@post.url_code}",
                  "display_name" =>  "阅读全文"
                },
                  "tags" =>  [ {
                  "display_name" =>  "#{@post.tag_list.first||""}" }
                ],
                  "create_at" => "#{@post.created_at||Time.now}",
                  "object_type" =>  "article"
                }
              else
                {
                  "errcode" => "-1",
                "msg" => "NotFound!"
              }
              end
            end
          else
            {
              "errcode" => "-1",
              "msg" => "NotFound!"
            }
          end
        end
      end

    end
  end
end
