module Admin::NewsflashesHelper
	def fast_news_type(f_type)
		["_newsflash", 'newsflash'].include?(f_type) ? '快讯' : '新产品'
	end
end
