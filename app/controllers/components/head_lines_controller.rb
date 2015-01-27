require "faraday"
require "json"

class Components::HeadLinesController < ApplicationController

  def index
    @head_lines = Redis::HashKey.new('head_lines')["list"]
    render :json => @head_lines
  end

end
