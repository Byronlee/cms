require "faraday"
require "json"

class Components::NextController < ApplicationController

  # TODO 将Token, collections 缓存一下，设置过期时间
  # TOOD 将 collecitons 缓存一下，设置过期时间
  # TODO collections 限制一下条数

  def collections
  	render :json => Faraday.get(Settings.next.collection_api+"?access_token="+token["access_token"]).body
  end

private

  def token
  	JSON.parse(Faraday.new(:url => Settings.next.host).post do | req |
      req.headers['Content-Type'] = 'application/json'
      req.body = Settings.next.token_params.to_json
    end.body)
  end
end
