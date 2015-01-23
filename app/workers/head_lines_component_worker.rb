class HeadLinesComponentWorker < BaseComponentWorker
  def perform
  	head_lines = Headline.order('updated_at desc').limit(4)
  	@collections = head_lines.inject([]) do | result, head_line |
  		result << prase(head_line.url)
    end 
    binding.pry
    Redis::HashKey.new('head_lines')["collections"] = @collections.to_json
  end

  private 

  def prase(url) 
	  og = OpenGraph.new(url)

	  { 
	    title:og.title,
	    type:og.type,
	    url:og.url,
	    image:og.images.first
    }
   end 
end