module Admin::NewsflashesHelper
	def fast_news_type(f_type)
		f_type.eql?("_newsflash") ? '快讯' : 'Product Note'
	end
end
