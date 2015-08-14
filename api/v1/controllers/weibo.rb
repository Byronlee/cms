module V1
  module Controllers
    class Weibo < ::V1::Base
      format :json
      #/api/v1/linkcard/topics?url=https://36kr.com/p/5035717
      #/api/v1/linkcard/topics?url=https://36kr.com/clipped/10118
      #/api/v1/linkcard/topics?url=https://36kr.com/clipped/11131
      resource :linkcard do

        desc 'weibo linkcard'
        params do
          optional :url,  type: String, desc: 'url'
        end
        get "topics" do
          url = params[:url]
          uri = url.scan(URI.regexp)
          #pid = uri[0][6].match(/\d+/)[0].to_i
          match_uri = uri[0][6]
          unless match_uri.nil?
            case match_uri
            when /^\/p\/(\d+)/
              @post = Post.find_by_url_code(match_uri.match(/^\/p\/(\d+)/)[1].to_i)
              #cache(key: "api:v1:weibo:linkcard:post", etag: Time.now, expires_in: Settings.api.expires_in) do
                weibo_post(@post)
              #end
            when /^\/clipped\/(\d+)/
              @newsflash = Newsflash.find(match_uri.match(/^\/clipped\/(\d+)/)[1].to_i)
              #cache(key: "api:v1:weibo:linkcard:clipped", etag: Time.now, expires_in: Settings.api.expires_in) do
                weibo_newsflash(@newsflash)
              #end
            else
              { "errcode" => "-1","msg" => "NotFound!" }
            end# end case

          else# unless
            { "errcode" => "-1","msg" => "NotFound!" }
          end #end unless

        end# end get


      end# end resource

    end
  end
end
