require "faraday"
require "json"

class Components::HeadLinesController < ApplicationController

  def collections
    collecitons = Redis::HashKey.new('head_lines')["collections"]
    render :json => collecitons
  end

end
