# == Schema Information
#
# Table name: newsflashes
#
#  id                       :integer          not null, primary key
#  original_input           :text
#  hash_title               :string(255)
#  description_text         :text
#  news_url                 :string(255)
#  newsflash_topic_color_id :integer
#  news_summaries           :string(8000)
#  created_at               :datetime
#  updated_at               :datetime
#  user_id                  :integer
#  cover                    :string(255)
#

require 'spec_helper'

describe Newsflash do
  context 'when original_input don`t has hash_title' do
    let(:input) { '这是第一天快新闻' }

    it 'shuld not save success' do
      newsflash = build :newsflash, original_input: input
      expect(newsflash.save).to eq(false)
      expect(newsflash.errors.first).to eq([:hash_title, '不能为空字符'])
    end
  end

  context 'when original_input with valide params' do
    let(:input) { '#这是第一天快新闻#哈哈哈，这是内容' }

    it 'shuld save success' do
      newsflash = create :newsflash, original_input: input
      expect(newsflash.original_input).to eq(input)
      expect(newsflash.hash_title).to eq('这是第一天快新闻')
      expect(newsflash.description_text).to eq('哈哈哈，这是内容')
    end
  end

  context 'when original_input with hash_title, description_text, news_url' do
    let(:input) { '#这是第一天快新闻#哈哈哈，这是内容http://baidu.com' }

    it 'shuld save success' do
      newsflash = create :newsflash, original_input: input
      expect(newsflash.original_input).to eq(input)
      expect(newsflash.hash_title).to eq('这是第一天快新闻')
      expect(newsflash.description_text).to eq('哈哈哈，这是内容')
      expect(newsflash.news_url).to eq('http://baidu.com')
    end
  end

  context 'when original_input with summaries' do
    let(:input) { '#这是第一天快新闻#哈哈哈，这是内容http://baidu.com------n1.asdfasdfn2.adsfasdfn3.sdfasd' }

    it 'shuld save success' do
      newsflash = create :newsflash, original_input: input
      expect(newsflash.original_input).to eq(input)
      expect(newsflash.hash_title).to eq('这是第一天快新闻')
      expect(newsflash.description_text).to eq('哈哈哈，这是内容')
      expect(newsflash.news_url).to eq('http://baidu.com')
    end
  end
end
