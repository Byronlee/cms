require "faraday"
require "json"

class Components::NextController < ApplicationController

  def collections
    collecitons = Redis::HashKey.new('next')["collections"] || NextComponentWorker.new.perform
    render :json => collecitons
  end

end
